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

  //if(r > 0.9f) return 1.0f;

  return n_1 * (-r * r * rootA * rootA / 2 + 1);



  /*//光ファイバー
  if(length(P.xy) > 0.4f ) return 2.3f;
  else return 1.5f;
  */


  //距離場の２乗
  //return 1.0f + D*D/2.0f;
  //return 1.0f+sin(P.z*Pi2);



  /*//氷 失敗
  float r = sqrt(P.x*P.x + P.y*P.y + P.z*P.z);
  return 1.4f - r/7.0f;
  */


  /*//トーラス用
  float r = D+0.9f;
  float n_1 = 1.5916f;
  float rootA = 0.327;
  return n_1 * (-r * r * rootA * rootA / 2 + 1);
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






///// 水面

bool MatWater( TRay*  const Ray,
               const  THit* Hit,
               uint4* const See,
               global  float4*   Beamer )
{
  float  IOR0, IOR1, F, d;
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
    Ray->Pos = Ray->Pos + (float)0.04 * Ray->Vec;


    if( dot( Ray->Vec, Nor_IOR( Ray->Pos ) ) < 0 )  Nor  = Nor_IOR(Ray->Pos);
    else  Nor  = -Nor_IOR(Ray->Pos);


    IOR0 = IOR( Ray->Pos + (float3)0.01*Nor);
    IOR1 = IOR( Ray->Pos - (float3)0.01*Nor);
    F = Fresnel( Ray->Vec, Nor, IOR0, IOR1 );

    if ( Rand( See ) < F ) Ray->Vec = Reflect( Ray->Vec, Nor             );  // 反射
                    else Ray->Vec = Refract( Ray->Vec, Nor, IOR0, IOR1 );  // 屈折



    /*////ビーム判定
    for(int i=0 ; i <= 2100 ; i++){
      d = length( Ray->Pos - Beamer[i].xyz );
      if( d < 0.03f && i<=700 ) Ray->Rad += (float3)( 0.2f, 0, 0);
      else if( d < 0.03f && i>=701 && i<=1400 ) Ray->Rad += (float3)( 0, 0.2f, 0);
      else if( d < 0.03f && i>=1401 && i<=2100 ) Ray->Rad += (float3)( 0, 0, 0.2f);
    }
    */

    //折れ線ビーム

  }


  return true;
}

//############################################################################## ■
#endif
