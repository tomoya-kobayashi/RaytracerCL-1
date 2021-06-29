//############################################################################## ■

#include<Math.cl>
#include<Math.D4x4.cl>
#include<Color.cl>
#include<Raytrace.core.cl>
#include<Raytrace.Object.cl>
#include<Raytrace.Material.cl>

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【型】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【定数】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ルーチン】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CheckHit

void CheckHit( THit* const Hit,
               const TTap* Tap,
               const int   Mat)
{
  if ( Tap->Dis < Hit->Dis )  // 物体毎の衝突距離 < 現在の最短衝突距離
  {
    Hit->Dis = Tap->Dis;
    Hit->Pos = Tap->Pos;
    Hit->Nor = Tap->Nor;
    Hit->Mat =      Mat;
  }
}

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Raytrace

void Raytrace( TRay*  const     Ray,
               uint4* const     See,
               const  image2d_t Tex,
               const  sampler_t Sam,
               global  float4*   Beamer)
{
  THit Hit;
  TTap Tap;
  bool Emi;

  for ( int N = 0; N < 10; N++ )
  {
    Hit.Dis = INFINITY;   // 衝突点までの距離
    Hit.Pos = (float3)0;  // 衝突点の位置
    Hit.Nor = (float3)0;  // 衝突点の法線
    Hit.Mat = 0;          // 衝突点の材質ＩＤ

    ///// 物体

    ///交差していたらヒットを確かめ、Hitパラメータを更新（同時に材質も選択）
    //if ( ObjPlain( Ray, &Tap ) ) CheckHit( &Hit, &Tap, 0 );  // 地面とレイの交差判定
    if ( ObjField( Ray, &Tap ) ) CheckHit( &Hit, &Tap, 2 );  // 球体とレイの交差判定

    ///// 材質

    switch( Hit.Mat )  // 材質の選択
    {
      case 0: Emi = MatSkyer( Ray, &Hit, See, Tex, Sam ); break;  // 空
      case 1: Emi = MatMirro( Ray, &Hit, See           ); break;  // 鏡面
      case 2: Emi = MatWater( Ray, &Hit, See, Beamer   ); break;  // 水面
    }

    //レイが交差しなければMatはskyのまま→輝度を対応する位置の"空"にした後、偽を返す→終了
    if ( !Emi ) break;  // 放射しなければ終了

    Ray->Pos += FLOAT_EPS3 * sign( dot( Ray->Vec, Hit.Nor ) ) * Hit.Nor;  // 放射点をシフト
  }
}

//############################################################################## ■

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Main

kernel void Main( write_only image2d_t  Imager,
                  read_write image2d_t  Seeder,
                  read_write image2d_t  Accumr,
                  global     TSingleM4* Camera,
                  read_only  image2d_t  Textur,
                  const      sampler_t  Samplr,
                  global     float4*    Beamer )
{
  TPix Pix;
  TEye Eye;
  TScr Scr;
  TCam Cam;
  TRay Ray;

  Pix.Siz = (int2)( get_global_size( 0 ), get_global_size( 1 ) );  // 画像のピクセル数
  Pix.Pos = (int2)( get_global_id  ( 0 ), get_global_id  ( 1 ) );  // ピクセルの整数座標
  Pix.See = read_imageui( Seeder, Pix.Pos );                       // 乱数シードを取得
  Pix.Rad = read_imagef ( Accumr, Pix.Pos );                       // ピクセル輝度を取得

  Eye.Pos = (float3)0;  // 視点位置

  Scr.Siz   = (float2)( 4, 3 );                                       // スクリーンのサイズ
  Scr.Pos.x = Scr.Siz.x * ( ( Pix.Pos.x + 0.5 ) / Pix.Siz.x - 0.5 );  // スクリーン上の標本位置
  Scr.Pos.y = Scr.Siz.y * ( 0.5 - ( Pix.Pos.y + 0.5 ) / Pix.Siz.y );
  Scr.Pos.z = -2;

  Cam.Mov = Camera[0];  // カメラの姿勢

  for ( int N = 1; N <= 16; N++ )
  {
    Ray.Pos = MulPos( Cam.Mov, Eye.Pos );                         // レイの出射位置
    Ray.Vec = MulVec( Cam.Mov, normalize( Scr.Pos - Eye.Pos ) );  // レイのベクトル
    Ray.Wei = (float3)1;                                          // レイのウェイト
    Ray.Rad = (float3)0;                                          // レイの輝度



    Raytrace( &Ray, &Pix.See, Textur, Samplr, Beamer );  // レイトレーシング

    Pix.Rad.w   += 1;                                                // 標本数
    Pix.Rad.xyz += ( Ray.Wei * Ray.Rad - Pix.Rad.xyz ) / Pix.Rad.w;  // ピクセル輝度
    ///ピクセルの輝度を複数の標本から平均して得る
  }

  Pix.Col = GammaCorrect( ToneMap( Pix.Rad.xyz, 100 ), 2.2 );  // ピクセル色

  write_imagef ( Accumr, Pix.Pos,           Pix.Rad      );  // ピクセル輝度を保存
  write_imageui( Seeder, Pix.Pos,           Pix.See      );  // 乱数シードを保存
  write_imagef ( Imager, Pix.Pos, (float4)( Pix.Col, 1 ) );  // ピクセル色を保存
}




//%%%%%%%%%%%%%%%%%%%%%%%%%%%%
kernel void GenBeamer( global float4* Beamer )
{

  float  IOR0, IOR1, F;
  float3 Nor;

  //円柱用ビーム45度
  float3 RayP = (float3)(0, 0, 3);
  float3 RayV = (float3)(0, 0.4, -1);
  RayV = normalize(RayV);

  /*//トーラス用ビーム
  float3 RayP = (float3)(0, 0, 4);
  float3 RayV = (float3)(0, 1, -0.5);
  RayV = normalize(RayV);
  */


  for ( int i = 0; i <= 2100; i++ )
  {

    //ビーム２本目
    if(i==701){
      RayP = (float3)(0, 0, 3);
      RayV = (float3)(0, -0.4, -1);
      RayV = normalize(RayV);
    }

    //ビーム3本目
    if(i==1401){
      RayP = (float3)(0, 0, 3);
      RayV = (float3)(0, 0.3, -1);
      RayV = normalize(RayV);
    }


    //レイの現在位置の座標をBeamer[i]に保存
    Beamer[i] = (float4)(RayP, 0);



    //法線ベクトルを取得

    if( dot( RayV, Nor_IOR( RayP ) ) < 0 )  Nor  = Nor_IOR(RayP);
                                      else  Nor  = -Nor_IOR(RayP);


    //屈折率を計算
    IOR0 = IOR( RayP + (float3)0.01*Nor);
    IOR1 = IOR( RayP - (float3)0.01*Nor);

    F = Fresnel( RayV, Nor, IOR0, IOR1 );


    //屈折or反射
    if(F >= 0.95f) RayV = normalize(Reflect( RayV, Nor));
            else  RayV = normalize(Refract( RayV, Nor, IOR0, IOR1 ));

    //レイの位置を更新
    RayP = RayP + 0.01f * RayV;

  }

}


//############################################################################## ■
