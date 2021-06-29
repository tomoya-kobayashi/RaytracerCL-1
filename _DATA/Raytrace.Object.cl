#ifndef RAYTRACE_OBJECT_CL
#define RAYTRACE_OBJECT_CL
//############################################################################## ■

#include<Math.cl>
#include<Raytrace.core.cl>

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【型】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【定数】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ルーチン】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ObjPlain
// 地面

bool ObjPlain( const TRay* Ray,
               TTap* const Tap )
{
  const float Z = -1;

  if ( 0 <= Ray->Vec.y ) return false;  // 交差なし

  Tap->Dis = ( Z - Ray->Pos.y ) / Ray->Vec.y;

  if ( Tap->Dis <= 0 ) return false;  // 交差なし

  Tap->Pos = Tap->Dis * Ray->Vec + Ray->Pos;
  Tap->Nor = (float3)( 0, 1, 0 );

  return true;  // 交差あり
}

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ObjSpher
// 球体

bool ObjSpher( const TRay* Ray,
               TTap* const Tap )
{
  const float R = 1;

  float B = dot( Ray->Pos, Ray->Vec );
  float C = Length2( Ray->Pos ) - Pow2( R );
  float D = Pow2( B ) - C;

  if ( D <= 0 ) return false;  // 交差なし

  Tap->Dis = -B - sign( C ) * sqrt( D );

  if ( Tap->Dis <= 0 ) return false;  // 交差なし

  Tap->Pos = Tap->Dis * Ray->Vec + Ray->Pos;
  Tap->Nor = Tap->Pos / R;

  return true;  // 交差あり
}

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ObjField
// 距離場

//トーラス
float GetDis1( const float3 P )
{
  const float LinR = 1.0f;
  const float PipR = 1.0f/3.0f;

  float2 Q = { P.x, length( P.yz ) - LinR };

  return length( Q ) - PipR;
}

//球体
float GetDis2( const float3 P )
{
  return length(P)-1.0;
}

//infinite cylinder
/*
float GetDis3( const float3 p )
{
  float3 c = (0f, 0f, 1.0f);

  if((p.z = -1.0) || (p.z = 1.0)){
    if(length(p.xy - c.xy) < 1.0) return 0;
  }else if((p.z > 1.0)||(p.z < -1.0)){
    return 1.0;
  }
  return length(p.xy-c.xy) - c.z;

}
*/

float GetDis( float3 P )
{

/* translation??
  P.x += 1.0f;
  P.y += 1.0f;
  P.z += 1.0f;
*/

  //float3 t = (1,1,1);
  //P = invert(t)*P;
  float3 q = fabs( P ) - (float3)( 1, 1, 1 );
  return length( max( q, 0.0f ) ) + min( max( q.x, max( q.y, q.z ) ), 0.0f );
}


//union
/*
float GetDis5( const float3 P )
{
  return max(GetDis1(P), -GetDis4(P));
}
*/



//------------------------------------------------------------------------------

float3 GetNor( const float3 P )
{
  const float3 Xd = { FLOAT_EPS2, 0, 0 };
  const float3 Yd = { 0, FLOAT_EPS2, 0 };
  const float3 Zd = { 0, 0, FLOAT_EPS2 };

  float3 Result;

  Result.x = GetDis( P + Xd ) - GetDis( P - Xd );
  Result.y = GetDis( P + Yd ) - GetDis( P - Yd );
  Result.z = GetDis( P + Zd ) - GetDis( P - Zd );

  return normalize( Result );
}


//------------------------------------------------------------------------------


////交差したらtrueを返す関数（そのためにspheretraceを使ってる）
bool ObjField( const TRay* Ray,
               TTap* const Tap )
{
  Tap->Dis = 0;
  for( int i = 0; i < 64; i++ )
  {
    Tap->Pos = Tap->Dis * Ray->Vec + Ray->Pos;

    float D = fabs( GetDis( Tap->Pos ) );

    Tap->Dis += D;

    if ( D < FLOAT_EPS2 )
    {
      Tap->Nor  = GetNor( Tap->Pos );
      Tap->Pos -= D * Tap->Nor;

      return true;  // 交差あり
    }
  }

  return false;  // 交差なし
}

//############################################################################## ■
#endif
