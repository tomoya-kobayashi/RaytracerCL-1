﻿unit LUX.GPU.OpenCL.Progra;

interface //#################################################################### ■

uses System.SysUtils, System.Classes, System.Generics.Collections,
     cl_version, cl_platform, cl,
     LUX.Data.List,
     LUX.Code.C,
     LUX.GPU.OpenCL.root,
     LUX.GPU.OpenCL.Device,
     LUX.GPU.OpenCL.Kernel;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【型】

     TCLProgras <TCLContex_,TCLPlatfo_:class> = class;
       TCLProgra<TCLContex_,TCLPlatfo_:class> = class;

     TCLLibrars <TCLContex_,TCLPlatfo_:class> = class;
       TCLLibrar<TCLContex_,TCLPlatfo_:class> = class;

     TCLExecuts     <TCLContex_,TCLPlatfo_:class> = class;
       TCLExecut    <TCLContex_,TCLPlatfo_:class> = class;
         TCLDeploys <TCLContex_,TCLPlatfo_:class> = class;
           TCLDeploy<TCLContex_,TCLPlatfo_:class> = class;

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【レコード】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【クラス】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TCLDeploy<TCLContex_,TCLPlatfo_>

     TCLDeploy<TCLContex_,TCLPlatfo_:class> = class( TListChildr<TCLProgra <TCLContex_,TCLPlatfo_>,
                                                                 TCLDeploys<TCLContex_,TCLPlatfo_>> )
     private
       type TCLDevice_  = TCLDevice <TCLPlatfo_>;
            TCLProgra_  = TCLProgra <TCLContex_,TCLPlatfo_>;
            TCLDeploys_ = TCLDeploys<TCLContex_,TCLPlatfo_>;
       ///// メソッド
       function Build :T_cl_int;
       function GetInfo<_TYPE_>( const Name_:T_cl_program_build_info ) :_TYPE_;
       function GetInfoSize( const Name_:T_cl_program_build_info ) :T_size_t;
       function GetInfos<_TYPE_>( const Name_:T_cl_program_build_info ) :TArray<_TYPE_>;
       function GetInfoString( const Name_:T_cl_program_build_info ) :String;
     protected
       _Device :TCLDevice_;
       _State  :T_cl_build_status;
       _Log    :String;
     public
       constructor Create( const Deploys_:TCLDeploys_; const Device_:TCLDevice_ ); overload; virtual;
       ///// プロパティ
       property Progra  :TCLProgra_        read GetOwnere;
       property Deploys :TCLDeploys_       read GetParent;
       property Device  :TCLDevice_        read   _Device;
       property State   :T_cl_build_status read   _State ;
       property Log     :String            read   _Log   ;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TCLDeploys<TCLContex_,TCLPlatfo_>

     TCLDeploys<TCLContex_,TCLPlatfo_:class> = class( TListParent<TCLProgra<TCLContex_,TCLPlatfo_>,
                                                                  TCLDeploy<TCLContex_,TCLPlatfo_>> )
     private
       type TCLDevice_ = TCLDevice<TCLPlatfo_>;
            TCLProgra_ = TCLProgra<TCLContex_,TCLPlatfo_>;
            TCLDeploy_ = TCLDeploy<TCLContex_,TCLPlatfo_>;
            TCLDevDeps = TDictionary<TCLDevice_,TCLDeploy_>;
     protected
       _DevDeps :TCLDevDeps;
       ///// イベント
       procedure OnInsertChild( const Childr_:TCLDeploy_ ); override;
       procedure OnRemoveChild( const Childr_:TCLDeploy_ ); override;
     public
       constructor Create; override;
       destructor Destroy; override;
       ///// プロパティ
       property Progra :TCLProgra_ read GetOwnere;
       ///// メソッド
       function Add( const Device_:TCLDevice_ ) :TCLDeploy_; overload;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TCLSource<TCLContex_,TCLPlatfo_>

     TCLSource<TCLContex_,TCLPlatfo_:class> = class( TStringList )
     private
       type TCLProgra_ = TCLProgra<TCLContex_,TCLPlatfo_>;
     protected
       _Progra :TCLProgra_;
       ///// メソッド
       procedure Changed; override;
     public
       constructor Create; overload; virtual;
       constructor Create( const Progra_:TCLProgra_ ); overload; virtual;
       ///// プロパティ
       property Progra :TCLProgra_ read _Progra;
       ///// メソッド
       procedure LoadFromFile( const FileName_:String ); override;
       procedure LoadFromFile( const FileName_:String; Encoding_:TEncoding ); override;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TCLProgra<TCLContex_,TCLPlatfo_>

     TCLProgra<TCLContex_,TCLPlatfo_:class> = class( TListChildr<TCLContex_,TCLProgras<TCLContex_,TCLPlatfo_>> )
     private
       type TCLDevice_  = TCLDevice <TCLPlatfo_>;
            TCLProgras_ = TCLProgras<TCLContex_,TCLPlatfo_>;
            TCLProgra_  = TCLProgra <TCLContex_,TCLPlatfo_>;
            TCLSource_  = TCLSource <TCLContex_,TCLPlatfo_>;
            TCLDeploys_ = TCLDeploys<TCLContex_,TCLPlatfo_>;
            TCLDeploy_  = TCLDeploy <TCLContex_,TCLPlatfo_>;
       ///// メソッド
       function GetInfo<_TYPE_>( const Name_:T_cl_program_info ) :_TYPE_;
       function GetInfoSize( const Name_:T_cl_program_info ) :T_size_t;
       function GetInfos<_TYPE_>( const Name_:T_cl_program_info ) :TArray<_TYPE_>;
       function GetInfoString( const Name_:T_cl_program_info ) :String;
     protected
       _Handle  :T_cl_program;
       _Name    :String;
       _Source  :TCLSource_;
       _LangVer :TCLVersion;
       _Deploys :TCLDeploys_;
       ///// アクセス
       function GetHandle :T_cl_program;
       procedure SetHandle( const Handle_:T_cl_program );
       (* cl_program_info *)
       function GetPROGRAM_REFERENCE_COUNT :T_cl_uint;
       function GetPROGRAM_CONTEXT :T_cl_context;
       function GetPROGRAM_NUM_DEVICES :T_cl_uint;
       function GetPROGRAM_DEVICES :TArray<T_cl_device_id>;
       function GetPROGRAM_SOURCE :String;
       function GetPROGRAM_BINARY_SIZES :TArray<T_size_t>;
       function GetPROGRAM_BINARIES :TArray<P_unsigned_char>;
       {$IF CL_VERSION_1_2 <> 0 }
       function GetPROGRAM_NUM_KERNELS :T_size_t;
       function GetPROGRAM_KERNEL_NAMES :String;
       {$ENDIF}
       {$IF CL_VERSION_2_1 <> 0 }
       function GetPROGRAM_IL :String;
       {$ENDIF}
       {$IF CL_VERSION_2_2 <> 0 }
       function GetPROGRAM_SCOPE_GLOBAL_CTORS_PRESENT :T_cl_bool ;
       function GetPROGRAM_SCOPE_GLOBAL_DTORS_PRESENT :T_cl_bool ;
       {$ENDIF}
       ///// メソッド
       procedure CreateHandle; virtual;
       procedure DestroHandle; virtual;
     public
       constructor Create; override;
       destructor Destroy; override;
       ///// プロパティ
       property Contex  :TCLContex_   read GetOwnere                 ;
       property Progras :TCLProgras_  read GetParent                 ;
       property Handle  :T_cl_program read GetHandle  write SetHandle;
       property Name    :String       read   _Name    write   _Name  ;
       property Source  :TCLSource_   read   _Source                 ;
       property LangVer :TCLVersion   read   _LangVer                ;
       property Deploys :TCLDeploys_  read   _Deploys                ;
       (* cl_program_info *)
       property PROGRAM_REFERENCE_COUNT            :T_cl_uint               read GetPROGRAM_REFERENCE_COUNT;
       property PROGRAM_CONTEXT                    :T_cl_context            read GetPROGRAM_CONTEXT;
       property PROGRAM_NUM_DEVICES                :T_cl_uint               read GetPROGRAM_NUM_DEVICES;
       property PROGRAM_DEVICES                    :TArray<T_cl_device_id>  read GetPROGRAM_DEVICES;
       property PROGRAM_SOURCE                     :String                  read GetPROGRAM_SOURCE;
       property PROGRAM_BINARY_SIZES               :TArray<T_size_t>        read GetPROGRAM_BINARY_SIZES;
       property PROGRAM_BINARIES                   :TArray<P_unsigned_char> read GetPROGRAM_BINARIES;
       {$IF CL_VERSION_1_2 <> 0 }
       property PROGRAM_NUM_KERNELS                :T_size_t                read GetPROGRAM_NUM_KERNELS;
       property PROGRAM_KERNEL_NAMES               :String                  read GetPROGRAM_KERNEL_NAMES;
       {$ENDIF}
       {$IF CL_VERSION_2_1 <> 0 }
       property PROGRAM_IL                         :String                  read GetPROGRAM_IL;
       {$ENDIF}
       {$IF CL_VERSION_2_2 <> 0 }
       property PROGRAM_SCOPE_GLOBAL_CTORS_PRESENT :T_cl_bool               read GetPROGRAM_SCOPE_GLOBAL_CTORS_PRESENT;
       property PROGRAM_SCOPE_GLOBAL_DTORS_PRESENT :T_cl_bool               read GetPROGRAM_SCOPE_GLOBAL_DTORS_PRESENT;
       {$ENDIF}
       ///// メソッド
       function BuildTo( const Device_:TCLDevice_ ) :TCLDeploy_;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TCLLibrar<TCLContex_,TCLPlatfo_>

     TCLLibrar<TCLContex_,TCLPlatfo_:class> = class( TCLProgra<TCLContex_,TCLPlatfo_> )
     private
     protected
     public
       constructor Create( const Contex_:TCLContex_ ); overload; virtual;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TCLExecut<TCLContex_,TCLPlatfo_>

     TCLExecut<TCLContex_,TCLPlatfo_:class> = class( TCLProgra<TCLContex_,TCLPlatfo_> )
     private
       type TCLLibrar_  = TCLLibrar <TCLContex_,TCLPlatfo_>;
            TCLExecut_  = TCLExecut <TCLContex_,TCLPlatfo_>;
            TCLKernels_ = TCLKernels<TCLExecut_,TCLContex_,TCLPlatfo_>;
     protected
       _ExeHan  :T_cl_program;
       _Kernels :TCLKernels_;
       ///// アクセス
       function GetExeHan :T_cl_program;
       procedure SetExeHan( const ExeHan_:T_cl_program );
       ///// メソッド
       procedure CreateHandle; override;
       procedure CreateExeHan; virtual;
       procedure DestroExeHan; virtual;
     public
       constructor Create; override;
       constructor Create( const Contex_:TCLContex_ ); overload; virtual;
       destructor Destroy; override;
       ///// プロパティ
       property ExeHan  :T_cl_program read GetExeHan  write SetExeHan;
       property Kernels :TCLKernels_  read   _Kernels                ;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TCLProgras<TCLContex_,TCLPlatfo_>

     TCLProgras<TCLContex_,TCLPlatfo_:class> = class( TListParent<TCLContex_,TCLProgra<TCLContex_,TCLPlatfo_>> )
     private
     protected
     public
       ///// プロパティ
       property Contex :TCLContex_ read GetOwnere;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TCLLibrars<TCLContex_,TCLPlatfo_>

     TCLLibrars<TCLContex_,TCLPlatfo_:class> = class( TCLProgras<TCLContex_,TCLPlatfo_> )
     private
       type TCLLibrar_   = TCLLibrar<TCLContex_,TCLPlatfo_>;
            TListEnumer_ = TListEnumer<TCLLibrar_>;
     protected
     public
       ///// メソッド
       function GetEnumerator :TListEnumer_;
       function Add :TCLLibrar_; overload;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TCLExecuts<TCLContex_,TCLPlatfo_>

     TCLExecuts<TCLContex_,TCLPlatfo_:class> = class( TCLProgras<TCLContex_,TCLPlatfo_> )
     private
       type TCLExecut_   = TCLExecut<TCLContex_,TCLPlatfo_>;
            TListEnumer_ = TListEnumer<TCLExecut_>;
     protected
     public
       ///// メソッド
       function GetEnumerator :TListEnumer_;
       function Add :TCLExecut_; overload;
     end;

//const //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【定数】

//var //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【変数】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ルーチン】

implementation //############################################################### ■

uses System.IOUtils,
     LUX.GPU.OpenCL;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【レコード】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【クラス】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TCLDeploy<TCLContex_,TCLPlatfo_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

/////////////////////////////////////////////////////////////////////// メソッド

function TCLDeploy<TCLContex_,TCLPlatfo_>.Build :T_cl_int;
var
   Os :String;
begin
     Os := '-cl-kernel-arg-info';

     if Ord( Progra.LangVer ) > 100 then Os := Os + ' -cl-std=CL' + Progra.LangVer.ToString;

     Result := clBuildProgram( Progra.Handle, 1, @Device.Handle, P_char( AnsiString( Os ) ), nil, nil );
end;

//------------------------------------------------------------------------------

function TCLDeploy<TCLContex_,TCLPlatfo_>.GetInfo<_TYPE_>( const Name_:T_cl_program_build_info ) :_TYPE_;
begin
     AssertCL( clGetProgramBuildInfo( Progra.Handle, Device.Handle, Name_, SizeOf( _TYPE_ ), @Result, nil ) );
end;

function TCLDeploy<TCLContex_,TCLPlatfo_>.GetInfoSize( const Name_:T_cl_program_build_info ) :T_size_t;
begin
     AssertCL( clGetProgramBuildInfo( Progra.Handle, Device.Handle, Name_, 0, nil, @Result ) );
end;

function TCLDeploy<TCLContex_,TCLPlatfo_>.GetInfos<_TYPE_>( const Name_:T_cl_program_build_info ) :TArray<_TYPE_>;
var
   S :T_size_t;
begin
     S := GetInfoSize( Name_ );

     SetLength( Result, S div Cardinal( SizeOf( _TYPE_ ) ) );

     AssertCL( clGetProgramBuildInfo( Progra.Handle, Device.Handle, Name_, S, @Result[ 0 ], nil ) );
end;

function TCLDeploy<TCLContex_,TCLPlatfo_>.GetInfoString( const Name_:T_cl_program_build_info ) :String;
begin
     Result := TrimRight( String( P_char( GetInfos<T_char>( Name_ ) ) ) );
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TCLDeploy<TCLContex_,TCLPlatfo_>.Create( const Deploys_:TCLDeploys_; const Device_:TCLDevice_ );
begin
     inherited Create( Deploys_ );

     _Device := Device_;

     Build;

     _State := GetInfo<T_cl_build_status>( CL_PROGRAM_BUILD_STATUS );
     _Log   := GetInfoString             ( CL_PROGRAM_BUILD_LOG    );
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TCLDeploys<TCLContex_,TCLPlatfo_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

/////////////////////////////////////////////////////////////////////// イベント

procedure TCLDeploys<TCLContex_,TCLPlatfo_>.OnInsertChild( const Childr_:TCLDeploy_ );
begin
     inherited;

     _DevDeps.Add( Childr_.Device, Childr_ );
end;

procedure TCLDeploys<TCLContex_,TCLPlatfo_>.OnRemoveChild( const Childr_:TCLDeploy_ );
begin
     inherited;

     _DevDeps.Remove( Childr_.Device );
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TCLDeploys<TCLContex_,TCLPlatfo_>.Create;
begin
     inherited;

     _DevDeps := TCLDevDeps.Create;
end;

destructor TCLDeploys<TCLContex_,TCLPlatfo_>.Destroy;
begin
     _DevDeps.Free;

     inherited;
end;

/////////////////////////////////////////////////////////////////////// メソッド

function TCLDeploys<TCLContex_,TCLPlatfo_>.Add( const Device_:TCLDevice_ ) :TCLDeploy_;
begin
     if _DevDeps.ContainsKey( Device_ ) then Result := _DevDeps[ Device_ ]
                                        else Result := TCLDeploy_.Create( Self, Device_ );
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TCLSource<TCLContex_,TCLPlatfo_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

/////////////////////////////////////////////////////////////////////// メソッド

procedure TCLSource<TCLContex_,TCLPlatfo_>.Changed;
begin
     inherited;

     _Progra.Handle := nil;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TCLSource<TCLContex_,TCLPlatfo_>.Create;
begin
     inherited;

end;

constructor TCLSource<TCLContex_,TCLPlatfo_>.Create( const Progra_:TCLProgra_ );
begin
     Create;

     _Progra := Progra_;
end;

/////////////////////////////////////////////////////////////////////// メソッド

procedure TCLSource<TCLContex_,TCLPlatfo_>.LoadFromFile( const FileName_:String );
begin
     inherited;

     Progra.Name := TPath.GetFileName( FileName_ );
end;

procedure TCLSource<TCLContex_,TCLPlatfo_>.LoadFromFile( const FileName_:String; Encoding_:TEncoding );
begin
     inherited;

     Progra.Name := TPath.GetFileName( FileName_ );
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TCLProgra<TCLContex_,TCLPlatfo_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

/////////////////////////////////////////////////////////////////////// メソッド

function TCLProgra<TCLContex_,TCLPlatfo_>.GetInfo<_TYPE_>( const Name_:T_cl_program_info ) :_TYPE_;
begin
     AssertCL( clGetProgramInfo( Handle, Name_, SizeOf( _TYPE_ ), @Result, nil ) );
end;

function TCLProgra<TCLContex_,TCLPlatfo_>.GetInfoSize( const Name_:T_cl_program_info ) :T_size_t;
begin
     AssertCL( clGetProgramInfo( Handle, Name_, 0, nil, @Result ) );
end;

function TCLProgra<TCLContex_,TCLPlatfo_>.GetInfos<_TYPE_>( const Name_:T_cl_program_info ) :TArray<_TYPE_>;
var
   S :T_size_t;
begin
     S := GetInfoSize( Name_ );

     SetLength( Result, S div Cardinal( SizeOf( _TYPE_ ) ) );

     AssertCL( clGetProgramInfo( Handle, Name_, S, @Result[ 0 ], nil ) );
end;

function TCLProgra<TCLContex_,TCLPlatfo_>.GetInfoString( const Name_:T_cl_program_info ) :String;
begin
     Result := TrimRight( String( P_char( GetInfos<T_char>( Name_ ) ) ) );
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

/////////////////////////////////////////////////////////////////////// アクセス

function TCLProgra<TCLContex_,TCLPlatfo_>.GetHandle :T_cl_program;
begin
     if not Assigned( _Handle ) then CreateHandle;

     Result := _Handle;
end;

procedure TCLProgra<TCLContex_,TCLPlatfo_>.SetHandle( const Handle_:T_cl_program );
begin
     if Assigned( _Handle ) then DestroHandle;

     _Handle := Handle_;
end;

//---------------------------------------------------------(* cl_program_info *)

function TCLProgra<TCLContex_,TCLPlatfo_>.GetPROGRAM_REFERENCE_COUNT :T_cl_uint; begin Result := GetInfo<T_cl_uint>( CL_PROGRAM_REFERENCE_COUNT ); end;
function TCLProgra<TCLContex_,TCLPlatfo_>.GetPROGRAM_CONTEXT :T_cl_context; begin Result := GetInfo<T_cl_context>( CL_PROGRAM_CONTEXT ); end;
function TCLProgra<TCLContex_,TCLPlatfo_>.GetPROGRAM_NUM_DEVICES :T_cl_uint; begin Result := GetInfo<T_cl_uint>( CL_PROGRAM_NUM_DEVICES ); end;
function TCLProgra<TCLContex_,TCLPlatfo_>.GetPROGRAM_DEVICES :TArray<T_cl_device_id>; begin Result := GetInfos<T_cl_device_id>( CL_PROGRAM_DEVICES ); end;
function TCLProgra<TCLContex_,TCLPlatfo_>.GetPROGRAM_SOURCE :String; begin Result := GetInfoString( CL_PROGRAM_SOURCE ); end;
function TCLProgra<TCLContex_,TCLPlatfo_>.GetPROGRAM_BINARY_SIZES :TArray<T_size_t>; begin Result := GetInfos<T_size_t>( CL_PROGRAM_BINARY_SIZES ); end;
function TCLProgra<TCLContex_,TCLPlatfo_>.GetPROGRAM_BINARIES :TArray<P_unsigned_char>; begin Result := GetInfos<P_unsigned_char>( CL_PROGRAM_BINARIES ); end;
{$IF CL_VERSION_1_2 <> 0 }
function TCLProgra<TCLContex_,TCLPlatfo_>.GetPROGRAM_NUM_KERNELS :T_size_t; begin Result := GetInfo<T_size_t>( CL_PROGRAM_NUM_KERNELS ); end;
function TCLProgra<TCLContex_,TCLPlatfo_>.GetPROGRAM_KERNEL_NAMES :String; begin Result := GetInfoString( CL_PROGRAM_KERNEL_NAMES ); end;
{$ENDIF}
{$IF CL_VERSION_2_1 <> 0 }
function TCLProgra<TCLContex_,TCLPlatfo_>.GetPROGRAM_IL :String; begin Result := GetInfoString( CL_PROGRAM_IL ); end;
{$ENDIF}
{$IF CL_VERSION_2_2 <> 0 }
function TCLProgra<TCLContex_,TCLPlatfo_>.GetPROGRAM_SCOPE_GLOBAL_CTORS_PRESENT :T_cl_bool; begin Result := GetInfo<T_cl_bool>( CL_PROGRAM_SCOPE_GLOBAL_CTORS_PRESENT ); end;
function TCLProgra<TCLContex_,TCLPlatfo_>.GetPROGRAM_SCOPE_GLOBAL_DTORS_PRESENT :T_cl_bool; begin Result := GetInfo<T_cl_bool>( CL_PROGRAM_SCOPE_GLOBAL_DTORS_PRESENT ); end;
{$ENDIF}

/////////////////////////////////////////////////////////////////////// メソッド

procedure TCLProgra<TCLContex_,TCLPlatfo_>.CreateHandle;
var
   C :P_char;
   E :T_cl_int;
begin
     C := P_char( AnsiString( _Source.Text ) );

     _Handle := clCreateProgramWithSource( TCLContex( Contex ).Handle, 1, @C, nil, @E );

     AssertCL( E );
end;

procedure TCLProgra<TCLContex_,TCLPlatfo_>.DestroHandle;
begin
     clReleaseProgram( _Handle );

     _Handle := nil;

     _Deploys.Clear;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TCLProgra<TCLContex_,TCLPlatfo_>.Create;
begin
     inherited;

     _Source  := TCLSource_ .Create( Self );
     _Deploys := TCLDeploys_.Create( Self );

     _Handle := nil;

     _LangVer := TCLVersion.From( '3.0' );
end;

destructor TCLProgra<TCLContex_,TCLPlatfo_>.Destroy;
begin
      Handle := nil;

     _Deploys.Free;
     _Source .Free;

     inherited;
end;

/////////////////////////////////////////////////////////////////////// メソッド

function TCLProgra<TCLContex_,TCLPlatfo_>.BuildTo( const Device_:TCLDevice_ ) :TCLDeploy_;
begin
     Result := Deploys.Add( Device_ );
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TCLLibrar<TCLContex_,TCLPlatfo_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TCLLibrar<TCLContex_,TCLPlatfo_>.Create( const Contex_:TCLContex_ );
begin
     inherited Create( TCLContex( Contex_ ).Librars );
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TCLExecut<TCLContex_,TCLPlatfo_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

/////////////////////////////////////////////////////////////////////// アクセス

function TCLExecut<TCLContex_,TCLPlatfo_>.GetExeHan :T_cl_program;
begin
     if not Assigned( _ExeHan ) then CreateExeHan;

     Result := _ExeHan;
end;

procedure TCLExecut<TCLContex_,TCLPlatfo_>.SetExeHan( const ExeHan_:T_cl_program );
begin
     if Assigned( _ExeHan ) then DestroExeHan;

     _ExeHan := ExeHan_;
end;

/////////////////////////////////////////////////////////////////////// メソッド

procedure TCLExecut<TCLContex_,TCLPlatfo_>.CreateHandle;
var
   Os :String;
   Hs :TArray<T_cl_program>;
   Ns :TArray<P_char>;
   L :TCLLibrar;
begin
     inherited;

     Os := '-cl-kernel-arg-info';
     if Ord( LangVer ) > 100 then Os := Os + ' -cl-std=CL' + LangVer.ToString;

     for L in TCLContex( Contex ).Librars do
     begin
          Hs := Hs + [ L.Handle ];
          Ns := Ns + [ P_char( AnsiString( L.Name ) ) ];
     end;

     AssertCL( clCompileProgram( _Handle, 0, nil, P_char( AnsiString( Os ) ),
                                 TCLContex( Contex ).Librars.Count, @Hs[0], @Ns[0],
                                 nil, nil ) );
end;

procedure TCLExecut<TCLContex_,TCLPlatfo_>.CreateExeHan;
var
   P :T_cl_program;
   E :T_cl_int;
begin
     P := Handle;

     _ExeHan := clLinkProgram( TCLContex( Contex ).Handle, 0, nil, nil, 1, @P, nil, nil, @E );

     AssertCL( E );
end;

procedure TCLExecut<TCLContex_,TCLPlatfo_>.DestroExeHan;
begin
     clReleaseProgram( _ExeHan );

     _ExeHan := nil;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TCLExecut<TCLContex_,TCLPlatfo_>.Create;
begin
     inherited;

     _Kernels := TCLKernels_.Create( Self );

     _ExeHan := nil;
end;

constructor TCLExecut<TCLContex_,TCLPlatfo_>.Create( const Contex_:TCLContex_ );
begin
     inherited Create( TCLContex( Contex_ ).Executs );
end;

destructor TCLExecut<TCLContex_,TCLPlatfo_>.Destroy;
begin
      ExeHan := nil;

     _Kernels.Free;

     inherited;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TCLProgras<TCLContex_,TCLPlatfo_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TCLLibrars<TCLContex_,TCLPlatfo_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

/////////////////////////////////////////////////////////////////////// メソッド

function TCLLibrars<TCLContex_,TCLPlatfo_>.Add :TCLLibrar_;
begin
     Result := TCLLibrar_.Create( Contex );
end;

/////////////////////////////////////////////////////////////////////// メソッド

function TCLLibrars<TCLContex_,TCLPlatfo_>.GetEnumerator: TListEnumer_;
begin
     Result := TListEnumer_.Create( Self );
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TCLExecuts<TCLContex_,TCLPlatfo_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

/////////////////////////////////////////////////////////////////////// メソッド

function TCLExecuts<TCLContex_,TCLPlatfo_>.Add :TCLExecut_;
begin
     Result := TCLExecut_.Create( Contex );
end;

/////////////////////////////////////////////////////////////////////// メソッド

function TCLExecuts<TCLContex_,TCLPlatfo_>.GetEnumerator: TListEnumer_;
begin
     Result := TListEnumer_.Create( Self );
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ルーチン】

end. //######################################################################### ■