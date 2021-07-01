#ifndef RAYTRACE_MATERIAL_CL
#define RAYTRACE_MATERIAL_CL
//############################################################################## ■

#include<Math.cl>
#include<Raytrace.core.cl>

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【型】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【定数】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ルーチン】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% MatSkyere
// 空

bool MatSkyer( TRay*  const     Ray,
               const  THit*     Hit,
               uint4* const     See,
               const  image2d_t Tex,
               const  sampler_t Sam )
{
  Ray->Rad += read_imagef( Tex, Sam, VecToSky( Ray->Vec ) ).xyz;  // 輝度を加算

  return false;  // レイトレーシングの中断
}

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% MatMirror
// 鏡面

bool MatMirro( TRay*  const Ray,
               const  THit* Hit,
               uint4* const See )
{
  Ray->Pos = Hit->Pos;                       // 反射位置
  Ray->Vec = Reflect( Ray->Vec, Hit->Nor );  // 反射ベクトル

  return true;  // レイトレーシングの続行
}

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% MatMirror








//////屈折率関数

float IOR( const float3 P){

  float D = GetDis(P);


  /*//-----default-------
  if(D <= 0) return 1.333f;
        else return 1.0f;
  */




  //ーーーセルフォックレンズーーー
  float r = sqrt(P.x*P.x + P.y*P.y);
  float n_1 = 1.5916f;
  float rootA = 0.327;
  return n_1 * (-r * r * rootA * rootA / 2 + 1);



  /*//光ファイバー（ステップ緩和）
  if(length(P.xy) < 0.4f ) return 1.51f;
  else if( length(P.xy) < 0.45f ) return length(P.xy) * (1.71f-1.51f)/0.05f + 1.51f;
  else return 1.71f;
  */


  /*
  //光ファイバー（ステップインデックス）
  if(length(P.xy) < 0.6f ) return 1.51f;
  else return 2.41f;
  */


  /*//光ファイバー（無限円柱）
  if(D < 0.5f ) return 1.51f;
  else if( D < 0.66f ) return length(P.xy) * (10.41f-1.51f)/0.16f + 1.51f;
  else return 1.0f;
  */

  //距離場の２乗
  //return 1.0f + D*D/2.0f;
  //return 1.0f+sin(P.z*Pi2);



  /*//氷 失敗
  float r = sqrt(P.x*P.x + P.y*P.y + P.z*P.z);
  return 1.4f - r/7.0f;
  */


  /*//トーラス用 セルフォックレンズ
  float r = D+0.9f;
  float n_1 = 1.5916f;
  float rootA = 0.327;
  return n_1 * (-r * r * rootA * rootA / 2 + 1);
  */


  /*//トーラス用　光ファイバー
  if(1.0f + D < 0.4f ) return 1.51f;
  else if( 1.0f + D < 0.45f ) return (1.0f + D) * (1.71f-1.51f)/0.05f + 1.51f;
  else return 1.71f;
  */


}






//////法線ベクトル取得
float3 Nor_IOR( const float3 P )
{
  const float3 Xd = { FLOAT_EPS2, 0, 0 };
  const float3 Yd = { 0, FLOAT_EPS2, 0 };
  const float3 Zd = { 0, 0, FLOAT_EPS2 };

  float3 Result;

  Result.x = IOR( P + Xd ) - IOR( P - Xd );
  Result.y = IOR( P + Yd ) - IOR( P - Yd );
  Result.z = IOR( P + Zd ) - IOR( P - Zd );

  return normalize( Result );
}







//////ビームとの距離取得
float Beam_Dis( const float3 P,
                const int start,
                const int stop,
                global float4* Beamer)
{
  //変数宣言
  float3 A, B, vecAB, vecAP;
  float d;
  int j=start;


  //距離が最小になる点の番号を保持(j)
  for(int i=start ; i <= stop ; i++){
    if( length(P - Beamer[i].xyz) < length(P - Beamer[j].xyz) ) j = i;
  }

  //距離が２番目に近い点を前後比較し決定
  if( j==0 ){
    A = Beamer[j].xyz;
    B = Beamer[j+1].xyz;
  }else if( length(P - Beamer[j-1].xyz) < length(P - Beamer[j+1].xyz) ){
    A = Beamer[j-1].xyz;
    B = Beamer[j].xyz;
  }else{
    A = Beamer[j].xyz;
    B = Beamer[j+1].xyz;
  }


  vecAB = B-A;
  vecAP = P-A;

  //線分ABとRay->Posとの距離
  d = length(vecAP) * sqrt( 1.0f - dot(vecAB, vecAP)/( length(vecAB)*length(vecAP) ) );


  return d;

}







///// 水面

bool MatWater( TRay*  const Ray,
               const  THit* Hit,
               uint4* const See,
               global  float4*   Beamer )
{
  float  IOR0, IOR1, F, d, dis;
  float3 Nor;


  if( dot( Ray->Vec, Hit->Nor ) < 0 )
  {
    IOR0 = 1.000;
    IOR1 = IOR(Hit->Pos);
    Nor  = +Hit->Nor;
  }
  else
  {
    IOR0 = IOR(Hit->Pos);
    IOR1 = 1.000;
    Nor  = -Hit->Nor;
  }

  F = Fresnel( Ray->Vec, Nor, IOR0, IOR1 );


  Ray->Pos = Hit->Pos;

  //同時に2本のレイは作れないので、確率で反射か屈折を選ぶ
  if ( Rand( See ) < F ) Ray->Vec = Reflect( Ray->Vec, Nor             );  // 反射
                    else Ray->Vec = Refract( Ray->Vec, Nor, IOR0, IOR1 );  // 屈折



  Ray->Pos += FLOAT_EPS3 * sign( dot( Ray->Vec, Hit->Nor ) ) * Hit->Nor;


  //レイをちょっとずつ進めて曲げる
  while( GetDis( Ray->Pos ) < 0 )
  {
    Ray->Pos = Ray->Pos + (float)0.03 * Ray->Vec;


    if( dot( Ray->Vec, Nor_IOR( Ray->Pos ) ) < 0 )  Nor  = Nor_IOR(Ray->Pos);
    else  Nor  = -Nor_IOR(Ray->Pos);


    IOR0 = IOR( Ray->Pos + (float3)0.01*Nor);
    IOR1 = IOR( Ray->Pos - (float3)0.01*Nor);
    F = Fresnel( Ray->Vec, Nor, IOR0, IOR1 );

    if ( Rand( See ) < F ) Ray->Vec = Reflect( Ray->Vec, Nor             );  // 反射
                    else Ray->Vec = Refract( Ray->Vec, Nor, IOR0, IOR1 );  // 屈折





    /*////ビーム判定（球体集合）
    for(int i=0 ; i <= 120 ; i++){
      d = length( Ray->Pos - Beamer[i].xyz );
      if( d < 0.03f && i<=39 ) Ray->Rad += (float3)( 0.4f, 0, 0);
      else if( d < 0.03f && i>=40 && i<=79 ) Ray->Rad += (float3)( 0, 0.2f, 0);
      else if( d < 0.03f && i>=80 && i<=119 ) Ray->Rad += (float3)( 0, 0, 0.2f);
    }
     */



    //ビーム1本目判定
    d = Beam_Dis(Ray->Pos, 0, 200, Beamer);
    //if(d < 0.02f) Ray->Rad += (float3)( 0.4f, 0, 0);
    //炎系ビーム
    Ray->Rad += (float3)( Gaussian(d*40.0f), Gaussian(d*80.0f), Gaussian(d*200.0f));

    /*
    //ビーム2本目判定
    d = Beam_Dis(Ray->Pos, 40, 79, Beamer);
    if(d < 0.02f) Ray->Rad += (float3)( 0.3f, 0, 0.34f);

    //ビーム3本目判定
    d = Beam_Dis(Ray->Pos, 80, 119, Beamer);
    if(d < 0.02f) Ray->Rad += (float3)( 0, 0.4f, 0.4f);

    //ビーム4本目判定
    d = Beam_Dis(Ray->Pos, 120, 159, Beamer);
    if(d < 0.02f) Ray->Rad += (float3)( 0.3f, 0, 0.4f);

    //ビーム5本目判定
    d = Beam_Dis(Ray->Pos, 160, 199, Beamer);
    if(d < 0.02f) Ray->Rad += (float3)( 0, 0, 0.9f);

    //ビーム6本目判定
    d = Beam_Dis(Ray->Pos, 200, 239, Beamer);
    if(d < 0.02f) Ray->Rad += (float3)( 0.1f, 0.325f, 0);
    */



  }


  return true;
}

//############################################################################## ■
#endif
