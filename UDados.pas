unit UDados;

interface

uses
  System.SysUtils, System.Classes, Data.DB, ZAbstractRODataset,
  ZAbstractDataset, ZDataset, ZAbstractConnection, ZConnection;

type
  TDMDados = class(TDataModule)
    CONEXAO: TZConnection;
    EstoqueBloq: TZQuery;
    EstoqueBloqproduto: TWideStringField;
    EstoqueBloqtipo: TWideStringField;
    EstoqueBloqdata_abate: TDateTimeField;
    EstoqueBloqhabilitacao: TWideStringField;
    EstoqueBloqquant: TIntegerField;
    Camaras: TZQuery;
    Camarascod_camara: TWideStringField;
    Camarasrastr: TWideStringField;
    Camarasquant: TIntegerField;
    Camarasperiodo: TWideStringField;
    CamarasDetalhe: TZQuery;
    CamarasDetalhecod_camara: TWideStringField;
    CamarasDetalheseq_abate: TIntegerField;
    CamarasDetalhecod_trilho: TWideStringField;
    CamarasDetalherastr: TWideStringField;
    CamarasDetalhenum_lote: TWideStringField;
    BalancaMapa: TZQuery;
    BalancaMapaseq_abate: TIntegerField;
    BalancaMapabanda: TWideStringField;
    BalancaMaparastr: TWideStringField;
    BalancaMapanum_lote: TWideStringField;
    BalancaMapadata_pes: TDateTimeField;
    BalancaMapacod_matur: TWideStringField;
    BalancaMapatempo: TIntegerField;
    CamarasDetalhebanda: TWideStringField;
    Acompanha: TZQuery;
    Acompanharestam: TFloatField;
    Acompanhaqtdlote: TFloatField;
    Acompanhaqtdabate: TFloatField;
    QuantidadesAbate: TZQuery;
    QuantidadesLote: TZQuery;
    QuantidadesAbaterastr: TWideStringField;
    QuantidadesAbatequant: TIntegerField;
    QuantidadesLotenum_lote: TWideStringField;
    QuantidadesLoterastr: TWideStringField;
    QuantidadesLotequant: TIntegerField;
    EscalaAbate: TZQuery;
    EscalaAbatelote: TWideStringField;
    EscalaAbateseq_lote: TWideStringField;
    EscalaAbatequant_lote: TFloatField;
    EscalaAbatecurrais: TWideStringField;
    EscalaAbatenome: TWideStringField;
    EscalaAbatenome_fazenda: TWideStringField;
    EscalaAbatehabilitacao: TWideStringField;
    EscalaAbatestatus_lote: TWideStringField;
    EscalaAbatebrincado: TWideStringField;
    qryExecuta: TZQuery;
    AbatesPecuarista: TZQuery;
    AbatesPecuaristadata_abate: TDateTimeField;
    AbatesPecuaristaquant: TFloatField;
    AbatesPecuaristanome: TWideStringField;
    AbatesPecuaristastatus: TWideStringField;
    AbatesPecuaristalote: TWideStringField;
    AbatesPecuaristapeso_abatido: TFloatField;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DMDados: TDMDados;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

end.
