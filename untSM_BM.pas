unit untSM_BM;

interface

uses System.SysUtils, System.Classes, System.Json,
    Datasnap.DSServer, Datasnap.DSAuth, UTipos, Dialogs, System.NetEncoding;

type
{$METHODINFO ON}
  TSM_BM = class(TDataModule)
  private
    { Private declarations }
    function Criptografa(texto: String):String;
    function Decriptografa(texto: String): String;
    function CalculaCnpjCpf(Numero : String) : Boolean;
    function ApenasNumerosStr(pStr:String): String;
    function IIf(pCond:Boolean;pTrue,pFalse:Variant): Variant;
  public
    { Public declarations }
    function EstoqueBloqueado: TJSONArray;
    function Camaras: TJSONArray;
    function CamarasDetalhe(CodCamara: String): TJSONArray;
    function BalancaMapa: TJSONArray;
    function Acompanha: TJSONArray;
    function QuantidadesAbate: TJSONArray;
    function QuantidadesLote(num_lote: String): TJSONArray;
    function EscalaAbate: TJSONArray;
    function ValidaUsuario(usuario, senha: String):TJSONArray;
    function CadastraUsuario(usuario, senha, cpf_cnpj: String):TJSONArray;
    function AbatesPecuarista(cgc: String): TJSONArray;
  end;
{$METHODINFO OFF}

implementation


{$R *.dfm}

uses UDados;


{ TSM_BM }

function TSM_BM.AbatesPecuarista(cgc: String): TJSONArray;
Var
  Dados: TDMDados;
  JsonArray: TJSONArray;
  JObj: TJSONObject;
begin
  try
    Dados := TDMDados.Create(nil);

    try
      if(Dados.CONEXAO.Connected = false) then
        Dados.CONEXAO.Connected := True;
      Dados.AbatesPecuarista.Active := False;
      Dados.AbatesPecuarista.ParamByName('cgc').AsString := Decriptografa(cgc);
      Dados.AbatesPecuarista.Active := True;
    finally

    end;

    JsonArray := TJSONArray.Create;

    Dados.AbatesPecuarista.First;
    while not Dados.AbatesPecuarista.Eof do
    begin
      JObj := TJSONObject.Create;
      JObj.AddPair('dataAbate',Dados.AbatesPecuaristadata_abate.AsString);
      JObj.AddPair('nome',Dados.AbatesPecuaristanome.AsString);
      JObj.AddPair('quant',Dados.AbatesPecuaristaquant.AsString);
      JsonArray.Add(JObj);
      Dados.AbatesPecuarista.Next;
    end;

    Result := JsonArray;

    Dados.AbatesPecuarista.Active := False;
    Dados.CONEXAO.Connected := False;

  finally
    if Assigned(Dados) then
      FreeAndNil(Dados);
  end;
end;

function TSM_BM.Acompanha: TJSONArray;
Var
  Dados: TDMDados;
  JsonArray: TJSONArray;
  JObj: TJSONObject;
begin
   try
    Dados := TDMDados.Create(nil);

    try
      if(Dados.CONEXAO.Connected = false) then
        Dados.CONEXAO.Connected := True;
      Dados.Acompanha.Active := False;
      Dados.Acompanha.Active := True;
    finally

    end;

    JsonArray := TJSONArray.Create;

    Dados.Acompanha.First;
    while not Dados.Acompanha.Eof do
    begin
      JObj := TJSONObject.Create;
      JObj.AddPair('total',Dados.Acompanhaqtdlote.AsString);
      JObj.AddPair('abatidos',Dados.Acompanhaqtdabate.AsString);
      JObj.AddPair('restam',Dados.Acompanharestam.AsString);
      JsonArray.Add(JObj);
      Dados.Acompanha.Next;
    end;

    Result := JsonArray;

    Dados.Acompanha.Active := False;
    Dados.CONEXAO.Connected := False;

  finally
    if Assigned(Dados) then
      FreeAndNil(Dados);
  end;
end;

function TSM_BM.ApenasNumerosStr(pStr: String): String;
Var
  I: Integer;
begin
  Result := '';
  For I := 1 To Length(pStr) do
   If pStr[I] In ['1','2','3','4','5','6','7','8','9','0'] Then
     Result := Result + pStr[I];
end;

function TSM_BM.BalancaMapa: TJSONArray;
Var
  Dados: TDMDados;
  JsonArray: TJSONArray;
  JObj: TJSONObject;
begin
   try
    Dados := TDMDados.Create(nil);

    try
      if(Dados.CONEXAO.Connected = false) then
        Dados.CONEXAO.Connected := True;
      Dados.BalancaMapa.Active := False;
      Dados.BalancaMapa.Active := True;
    finally

    end;

    JsonArray := TJSONArray.Create;

    Dados.BalancaMapa.First;
    while not Dados.BalancaMapa.Eof do
    begin
      JObj := TJSONObject.Create;
      JObj.AddPair('seqAbate',Dados.BalancaMapaseq_abate.AsString);
      JObj.AddPair('banda',Dados.BalancaMapabanda.AsString);
      JObj.AddPair('habilitacao',Dados.BalancaMaparastr.AsString);
      JObj.AddPair('numLote',Dados.BalancaMapanum_lote.AsString);
      JObj.AddPair('dataPes',FormatDateTime('dd-MM-yyyy hh:mm:ss',Dados.BalancaMapadata_pes.AsDateTime));
      JObj.AddPair('codMatur',Dados.BalancaMapacod_matur.AsString);
      JObj.AddPair('tempo',Dados.BalancaMapatempo.AsString);
      JsonArray.Add(JObj);
      Dados.BalancaMapa.Next;
    end;

    Result := JsonArray;

    Dados.BalancaMapa.Active := False;
    Dados.CONEXAO.Connected := False;

  finally
    if Assigned(Dados) then
      FreeAndNil(Dados);
  end;
end;

function TSM_BM.CadastraUsuario(usuario, senha, cpf_cnpj: String): TJSONArray;
Var
  Dados: TDMDados;
  JsonArray: TJSONArray;
  JObj: TJSONObject;
  CodRetorno: String;
begin
  try
    Dados := TDMDados.Create(nil);

    cpf_cnpj := Decriptografa(cpf_cnpj);
    usuario := Decriptografa(usuario);

    try
      if(Dados.CONEXAO.Connected = false) then
        Dados.CONEXAO.Connected := True;

      //SE CPF OU CNPJ VALIDO
      if(CalculaCnpjCpf(cpf_cnpj)) then
      begin
        //VERIFICO SE USUARIO JA ESTA CADASTRADO
        Dados.qryExecuta.SQL.Clear;
        Dados.qryExecuta.SQL.Add('select count(1) as quant from bm_usuario_app where usuario = ''' + usuario + '''');
        Dados.qryExecuta.Active := True;
        //SE N�O EXISTIR OUTRO USUARIO COM O MESMO NOME
        if(Dados.qryExecuta.FieldByName('quant').AsInteger  = 0) then
        begin
          //GRAVO OS DADOS NO BANCO
          Dados.qryExecuta.Active := False;
          Dados.qryExecuta.SQL.Clear;
          Dados.qryExecuta.SQL.Add('insert into bm_usuario_app (cpf_cnpj, usuario, senha) values (:cpf_cnpj, :usuario, :senha);');
          Dados.qryExecuta.ParamByName('cpf_cnpj').AsString := cpf_cnpj;
          Dados.qryExecuta.ParamByName('usuario').AsString := usuario;
          Dados.qryExecuta.ParamByName('senha').AsString := senha;
          Dados.qryExecuta.ExecSQL;

          //VALIDO OS DADOS GRAVADOS
          Dados.qryExecuta.SQL.Clear;
          Dados.qryExecuta.SQL.Add('select count(1) as quant from bm_usuario_app where usuario = ''' + usuario + '''');
          Dados.qryExecuta.Active := True;
          if(Dados.qryExecuta.FieldByName('quant').AsInteger  = 0) then
            CodRetorno := 'RET003' //ERRO AO CADASTRAR USUARIO
          else
            CodRetorno := 'RET000'; //SUCESSO AO CADASTRAR
          Dados.qryExecuta.Active := False;
        end
        else
          CodRetorno := 'RET002';  //USUARIO JA CADASTRADO
      end
      else
        CodRetorno := 'RET001';  //CPF OU CNPJ inv�lido
    finally

    end;

    JsonArray := TJSONArray.Create;
    JObj := TJSONObject.Create;
    JObj.AddPair('result',CodRetorno);
    JsonArray.Add(JObj);

    Result := JsonArray;

    Dados.CONEXAO.Connected := False;

  finally
    if Assigned(Dados) then
      FreeAndNil(Dados);
  end;
end;

function TSM_BM.CalculaCnpjCpf(Numero: String): Boolean;
Var
  i,d,b,Digito : Byte;
  Soma : Integer;
  CNPJ : Boolean;
  DgPass,DgCalc : String;
begin
  Result := False;
  Numero := ApenasNumerosStr(Numero);
  // Caso o n�mero n�o seja 11 (CPF) ou 14 (CNPJ), aborta
  Case Length(Numero) of
    11: CNPJ := False;
    14: CNPJ := True;
  else Exit;
  end;
  // Separa o n�mero do digito
  DgCalc := '';
  DgPass := Copy(Numero,Length(Numero)-1,2);
  Numero := Copy(Numero,1,Length(Numero)-2);
  // Calcula o digito 1 e 2
  For d := 1 to 2 do begin
    B := IIF(D=1,2,3); // BYTE
    SOMA := IIF(D=1,0,STRTOINTDEF(DGCALC,0)*2);
    for i := Length(Numero) downto 1 do begin
      Soma := Soma + (Ord(Numero[I])-Ord('0'))*b;
      Inc(b);
      If (b > 9) And CNPJ Then
        b := 2;
    end;
   Digito := 11 - Soma mod 11;
   If Digito >= 10 then
     Digito := 0;
   DgCalc := DgCalc + Chr(Digito + Ord('0'));
  end;
  Result := DgCalc = DgPass;
end;


function TSM_BM.Camaras: TJSONArray;
Var
  Dados: TDMDados;
  JsonArray: TJSONArray;
  JObj: TJSONObject;
begin
   try
    Dados := TDMDados.Create(nil);

    try
      if(Dados.CONEXAO.Connected = false) then
        Dados.CONEXAO.Connected := True;
      Dados.Camaras.Active := False;
      Dados.Camaras.Active := True;
    finally

    end;

    JsonArray := TJSONArray.Create;

    Dados.Camaras.First;
    while not Dados.Camaras.Eof do
    begin
      JObj := TJSONObject.Create;
      JObj.AddPair('codCamara',Dados.Camarascod_camara.AsString);
      JObj.AddPair('habilitacao',Dados.Camarasrastr.AsString);
      JObj.AddPair('quantidade',Dados.Camarasquant.AsString);
      JObj.AddPair('periodo',Dados.Camarasperiodo.AsString);
      JsonArray.Add(JObj);
      Dados.Camaras.Next;
    end;

    Result := JsonArray;

    Dados.Camaras.Active := False;
    Dados.CONEXAO.Connected := False;

  finally
    if Assigned(Dados) then
      FreeAndNil(Dados);
  end;
end;

function TSM_BM.CamarasDetalhe(CodCamara: String): TJSONArray;
Var
  Dados: TDMDados;
  JsonArray: TJSONArray;
  JObj: TJSONObject;
begin
  try
    Dados := TDMDados.Create(nil);

    try
      if(Dados.CONEXAO.Connected = false) then
        Dados.CONEXAO.Connected := True;
      Dados.CamarasDetalhe.Active := False;
      Dados.CamarasDetalhe.ParamByName('cod_camara').AsString := CodCamara;
      Dados.CamarasDetalhe.Active := True;
    finally

    end;

    JsonArray := TJSONArray.Create;

    Dados.CamarasDetalhe.First;
    while not Dados.CamarasDetalhe.Eof do
    begin
      JObj := TJSONObject.Create;
      JObj.AddPair('codCamara',Dados.CamarasDetalhecod_camara.AsString);
      JObj.AddPair('seqAbate',Dados.CamarasDetalheseq_abate.AsString);
      JObj.AddPair('banda',Dados.CamarasDetalhebanda.AsString);
      JObj.AddPair('codTrilho',Dados.CamarasDetalhecod_trilho.AsString);
      JObj.AddPair('habilitacao',Dados.CamarasDetalherastr.AsString);
      JObj.AddPair('numLote',Dados.CamarasDetalhenum_lote.AsString);
      JsonArray.Add(JObj);
      Dados.CamarasDetalhe.Next;
    end;

    Result := JsonArray;

    Dados.CamarasDetalhe.Active := False;
    Dados.CONEXAO.Connected := False;

  finally
    if Assigned(Dados) then
      FreeAndNil(Dados);
  end;

end;

function TSM_BM.Criptografa(texto: String): String;
begin
    Result := TNetEncoding.Base64.Encode(texto);
end;

function TSM_BM.Decriptografa(texto: String): String;
begin
  Result := TNetEncoding.Base64.Decode(texto);
end;

function TSM_BM.EscalaAbate: TJSONArray;
Var
  Dados: TDMDados;
  JsonArray: TJSONArray;
  JObj: TJSONObject;
begin
  try
    Dados := TDMDados.Create(nil);

    try
      if(Dados.CONEXAO.Connected = false) then
        Dados.CONEXAO.Connected := True;
      Dados.EscalaAbate.Active := False;
      Dados.EscalaAbate.Active := True;
    finally

    end;

    JsonArray := TJSONArray.Create;

    Dados.EscalaAbate.First;
    while not Dados.EscalaAbate.Eof do
    begin
      JObj := TJSONObject.Create;
      JObj.AddPair('lote',Dados.EscalaAbatelote.AsString);
      JObj.AddPair('subLote',Dados.EscalaAbateseq_lote.AsString);
      JObj.AddPair('quantLote',Dados.EscalaAbatequant_lote.AsString);
      JObj.AddPair('currais',Dados.EscalaAbatecurrais.AsString);
      JObj.AddPair('nome',Dados.EscalaAbatenome.AsString);
      JObj.AddPair('nomeFazenda',Dados.EscalaAbatenome_fazenda.AsString);
      JObj.AddPair('statusLote',Dados.EscalaAbatestatus_lote.AsString);
      JObj.AddPair('habilitacao',Dados.EscalaAbatehabilitacao.AsString);
      JObj.AddPair('brincado',Dados.EscalaAbatebrincado.AsString);
      JsonArray.Add(JObj);
      Dados.EscalaAbate.Next;
    end;

    Result := JsonArray;

    Dados.EscalaAbate.Active := False;
    Dados.CONEXAO.Connected := False;

  finally
    if Assigned(Dados) then
      FreeAndNil(Dados);
  end;
end;

function TSM_BM.EstoqueBloqueado: TJSONArray;
Var
  Dados: TDMDados;
  JsonArray: TJSONArray;
  JObj: TJSONObject;
begin
  try
    Dados := TDMDados.Create(nil);

    try
      if(Dados.CONEXAO.Connected = false) then
        Dados.CONEXAO.Connected := True;
      Dados.EstoqueBloq.Active := False;
      Dados.EstoqueBloq.Active := True;
    finally

    end;

    JsonArray := TJSONArray.Create;

    Dados.EstoqueBloq.First;
    while not Dados.EstoqueBloq.Eof do
    begin
      JObj := TJSONObject.Create;
      JObj.AddPair('produto',Dados.EstoqueBloqproduto.AsString);
      JObj.AddPair('tipo',Dados.EstoqueBloqtipo.AsString);
      JObj.AddPair('dataAbate',FormatDateTime('dd-MM-yyyy',Dados.EstoqueBloqdata_abate.AsDateTime));
      JObj.AddPair('habilitacao',Dados.EstoqueBloqhabilitacao.AsString);
      JObj.AddPair('quantidade',Dados.EstoqueBloqquant.AsString);
      JsonArray.Add(JObj);
      Dados.EstoqueBloq.Next;
    end;

    Result := JsonArray;

    Dados.EstoqueBloq.Active := False;
    Dados.CONEXAO.Connected := False;

  finally
    if Assigned(Dados) then
      FreeAndNil(Dados);
  end;

end;

function TSM_BM.IIf(pCond: Boolean; pTrue, pFalse: Variant): Variant;
begin
  If pCond Then
    Result := pTrue
  else
    Result := pFalse;
end;

function TSM_BM.QuantidadesAbate: TJSONArray;
Var
  Dados: TDMDados;
  JsonArray: TJSONArray;
  JObj: TJSONObject;
begin
   try
    Dados := TDMDados.Create(nil);

    try
      if(Dados.CONEXAO.Connected = false) then
        Dados.CONEXAO.Connected := True;
      Dados.QuantidadesAbate.Active := False;
      Dados.QuantidadesAbate.Active := True;
    finally

    end;

    JsonArray := TJSONArray.Create;

    Dados.QuantidadesAbate.First;
    while not Dados.QuantidadesAbate.Eof do
    begin
      JObj := TJSONObject.Create;
      JObj.AddPair('habilitacao',Dados.QuantidadesAbaterastr.AsString);
      JObj.AddPair('quantidade',Dados.QuantidadesAbatequant.AsString);
      JsonArray.Add(JObj);
      Dados.QuantidadesAbate.Next;
    end;

    Result := JsonArray;

    Dados.QuantidadesAbate.Active := False;
    Dados.CONEXAO.Connected := False;

  finally
    if Assigned(Dados) then
      FreeAndNil(Dados);
  end;
end;

function TSM_BM.QuantidadesLote(num_lote: String): TJSONArray;
Var
  Dados: TDMDados;
  JsonArray: TJSONArray;
  JObj: TJSONObject;
begin
  if (num_lote = '') then
    num_lote := '00';
   try
    Dados := TDMDados.Create(nil);

    try
      if(Dados.CONEXAO.Connected = false) then
        Dados.CONEXAO.Connected := True;
      Dados.QuantidadesLote.Active := False;
      Dados.QuantidadesLote.ParamByName('num_lote').AsString := num_lote;
      Dados.QuantidadesLote.Active := True;
    finally

    end;

    JsonArray := TJSONArray.Create;

    Dados.QuantidadesLote.First;
    while not Dados.QuantidadesLote.Eof do
    begin
      JObj := TJSONObject.Create;
      JObj.AddPair('numLote',Dados.QuantidadesLotenum_lote.AsString);
      JObj.AddPair('habilitacao',Dados.QuantidadesLoterastr.AsString);
      JObj.AddPair('quantidade',Dados.QuantidadesLotequant.AsString);
      JsonArray.Add(JObj);
      Dados.QuantidadesLote.Next;
    end;

    Result := JsonArray;

    Dados.QuantidadesLote.Active := False;
    Dados.CONEXAO.Connected := False;

  finally
    if Assigned(Dados) then
      FreeAndNil(Dados);
  end;
end;

function TSM_BM.ValidaUsuario(usuario, senha: String): TJSONArray;
Var
  Dados: TDMDados;
  JsonArray: TJSONArray;
  JObj: TJSONObject;
  CodRetorno: String;
  CGC: String;
  Tipo: String;
begin
   try
    Dados := TDMDados.Create(nil);

    usuario := Decriptografa(usuario);
    CGC := '';
    Tipo := '2';

    try
      if(Dados.CONEXAO.Connected = false) then
        Dados.CONEXAO.Connected := True;
      Dados.qryExecuta.SQL.Clear;
      Dados.qryExecuta.SQL.Add('select usuario, senha, cpf_cnpj, count(1) as quant from bm_usuario_app where usuario = ''' + usuario + ''' group by usuario, senha, cpf_cnpj');
      Dados.qryExecuta.Active := True;
      if(Dados.qryExecuta.FieldByName('quant').AsInteger > 0) then
      begin
        if(Dados.qryExecuta.FieldByName('senha').AsString = senha) then
        begin
          CodRetorno := 'RET000'; //LOGIN E SENHA CORRETOS
          CGC := Dados.qryExecuta.FieldByName('cpf_cnpj').AsString;
        end
        else
        begin
          CodRetorno := 'RET002'; //LOGIN E SENHA INCORRETOS
        end
      end
      else
        CodRetorno := 'RET001'; //USUARIO NAO ENCONTRADO
      Dados.qryExecuta.Active := False;

    finally

    end;

    JsonArray := TJSONArray.Create;
    JObj := TJSONObject.Create;
    JObj.AddPair('result',CodRetorno);
    JObj.AddPair('cgc',CGC);
    JObj.AddPair('tipo',Tipo); //1-adm / 2-pecuarista / 3-assessoria de abate
    JsonArray.Add(JObj);

    Result := JsonArray;

    Dados.CONEXAO.Connected := False;

  finally
    if Assigned(Dados) then
      FreeAndNil(Dados);
  end;
end;

end.

