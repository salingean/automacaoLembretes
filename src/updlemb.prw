#include "totvs.ch"
#include "topconn.ch"

/*/{Protheus.doc} UPDLEMB
    Configura o dicionario da tabela ZZL (Nova estrutura 2+2).
/*/
User Function UPDLEMB()

    Local cTabela := "ZZL"

    // ============================================================
    // SX2
    // ============================================================
    MyPutSX2(cTabela, "REGRAS DE LEMBRETES", "ZZL_CODFL+ZZL_FILIAL+ZZL_DESC")

    // ============================================================
    // SX3
    // ============================================================
    MyPutSX3("ZZL_CODFL",  "C", 2,  0, "Cod.Empresa",     "",              cTabela, "01", "")
    MyPutSX3("ZZL_FILIAL", "C", 2,  0, "Cod.Filial",      "",              cTabela, "02", "SM0")
    MyPutSX3("ZZL_DESC",   "C", 40, 0, "Descricao",       "",              cTabela, "03", "")
    MyPutSX3("ZZL_TIPO",   "C", 3,  0, "Tipo Titulo",     "@!",            cTabela, "04", "05")
    MyPutSX3("ZZL_NATURE", "C", 10, 0, "Natureza",        "@!",            cTabela, "05", "SED")
    MyPutSX3("ZZL_FORN",   "C", 6,  0, "Fornecedor",      "",              cTabela, "06", "FOR")
    MyPutSX3("ZZL_VENC",   "C", 8,  0, "Data Vencimento", "@R 99/99/9999", cTabela, "07", "")
    MyPutSX3("ZZL_RECOR",  "L", 1,  0, "Recorrente",      "",              cTabela, "08", "")
    MyPutSX3("ZZL_AVISO",  "N", 2,  0, "Dias Aviso",      "99",            cTabela, "09", "")
    MyPutSX3("ZZL_EMAIL",  "C", 50, 0, "Email Destino",   "",              cTabela, "10", "")

    // ============================================================
    // SIX
    // ============================================================
    MyPutSIX(cTabela, "1", "ZZL_CODFL+ZZL_FILIAL+ZZL_DESC", "Empresa + Filial + Descricao")

    MyEnsureTable(cTabela)
    MyInsertExemplo(cTabela)

    MsgInfo("Dicionario e estrutura fisica da ZZL atualizados para padrao 2+2.", "UPDLEMB")

Return

/*/{Protheus.doc} MyPutSX2
/*/
Static Function MyPutSX2(cTabela, cDescricao, cUnico)
    dbSelectArea("SX2")
    SX2->(DbSetOrder(1))
    If SX2->(DbSeek(cTabela))
        RecLock("SX2", .F.)
    Else
        RecLock("SX2", .T.)
    EndIf
    SX2->X2_CHAVE   := cTabela
    SX2->X2_ARQUIVO := cTabela
    SX2->X2_NOME    := cDescricao
    SX2->X2_ROTINA  := cTabela
    SX2->X2_UNICO   := cUnico
    SX2->X2_MODO    := "C"
    SX2->X2_MODULO  := 6
    MsUnlock()
Return

/*/{Protheus.doc} MyPutSX3
/*/
Static Function MyPutSX3(cCampo, cTipo, nTam, nDec, cTitulo, cPicture, cTabela, cOrdem, cF3)
    Default cF3 := ""
    dbSelectArea("SX3")
    SX3->(DbSetOrder(2))
    If SX3->(DbSeek(cCampo))
        RecLock("SX3", .F.)
    Else
        RecLock("SX3", .T.)
    EndIf
    SX3->X3_ARQUIVO := cTabela
    SX3->X3_CAMPO   := cCampo
    SX3->X3_ORDEM   := cOrdem
    SX3->X3_TIPO    := cTipo
    SX3->X3_TAMANHO := nTam
    SX3->X3_DECIMAL := nDec
    SX3->X3_TITULO  := cTitulo
    SX3->X3_TITSPA  := cTitulo
    SX3->X3_TITENG  := cTitulo
    SX3->X3_DESCRIC := cTitulo
    SX3->X3_DESCSPA := cTitulo
    SX3->X3_DESCENG := cTitulo
    SX3->X3_PICTURE := cPicture
    SX3->X3_CONTEXT := "R"
    SX3->X3_PROPRI  := "U"
    SX3->X3_NIVEL   := 1
    SX3->X3_USADO   := Replicate(Chr(128),15)
    SX3->X3_VISUAL  := "A"
    SX3->X3_BROWSE  := "S"
    SX3->X3_RELACAO := ""
    If cCampo $ "ZZL_CODFL/ZZL_FILIAL/ZZL_DESC/ZZL_TIPO/ZZL_VENC/ZZL_AVISO/ZZL_EMAIL"
        SX3->X3_OBRIGAT := Chr(128)
    Else
        SX3->X3_OBRIGAT := ""
    EndIf
    SX3->X3_F3      := cF3
    SX3->X3_RESERV  := ""
    SX3->X3_CHECK   := ""
    SX3->X3_TRIGGER := ""
    SX3->X3_VLDUSER := ""
    SX3->X3_CBOX    := ""
    SX3->X3_WHEN    := ""
    SX3->X3_INIBRW  := ""
    SX3->X3_GRPSXG  := ""
    SX3->X3_FOLDER  := "1"
    MsUnlock()
Return

/*/{Protheus.doc} MyPutSIX
/*/
Static Function MyPutSIX(cTabela, cOrdem, cChave, cDescricao)
    dbSelectArea("SIX")
    SIX->(DbSetOrder(1))
    If SIX->(DbSeek(cTabela + cOrdem))
        RecLock("SIX", .F.)
    Else
        RecLock("SIX", .T.)
    EndIf
    SIX->INDICE     := cTabela
    SIX->ORDEM      := cOrdem
    SIX->CHAVE      := cChave
    SIX->DESCRICAO  := cDescricao
    SIX->DESCSPA    := cDescricao
    SIX->DESCENG    := cDescricao
    SIX->NICKNAME   := cTabela + cOrdem
    SIX->PROPRI     := "U"
    SIX->F3         := ""
    SIX->SHOWPESQ   := "2"
    SIX->IX_VIRTUAL := ""
    SIX->IX_VIRCUST := ""
    MsUnlock()
Return

/*/{Protheus.doc} MyEnsureTable
/*/
Static Function MyEnsureTable(cTabela)
    Local cSqlTab  := RetSqlName(cTabela)
    Local aStruct  := {}
    Local cAlias   := GetNextAlias()
    Local lExists  := .F.
    Local cCreate  := ""
    Local nI       := 0
    Local cTipo, nTam, nDec, cField, cSqlType, cDefVal

    If FindFunction("ChkFile")
        Begin Sequence
            ChkFile(cTabela)
        End Sequence
    EndIf

    dbSelectArea("SX3")
    SX3->(DbSetOrder(1))
    SX3->(DbSeek(cTabela))
    While !SX3->(Eof()) .And. SX3->X3_ARQUIVO == cTabela
        AAdd(aStruct, {SX3->X3_CAMPO, SX3->X3_TIPO, SX3->X3_TAMANHO, SX3->X3_DECIMAL})
        SX3->(DbSkip())
    EndDo

    If Len(aStruct) == 0
        Return
    EndIf

    Begin Sequence
        dbUseArea(.T., "TOPCONN", TCGenQry(,, "SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = '" + cSqlTab + "'"), cAlias, .F., .T.)
        lExists := !(cAlias)->(Eof())
        (cAlias)->(DbCloseArea())
    Recover
        lExists := .F.
    End Sequence

    If !lExists
        cCreate := "CREATE TABLE " + cSqlTab + " ("
        For nI := 1 To Len(aStruct)
            cField := aStruct[nI][1]
            cTipo  := aStruct[nI][2]
            nTam   := aStruct[nI][3]
            nDec   := aStruct[nI][4]
            Do Case
            Case cTipo == "C"
                cSqlType := "CHAR(" + cValToChar(nTam) + ")"
                cDefVal  := "DEFAULT '" + Space(nTam) + "'"
            Case cTipo == "D"
                cSqlType := "CHAR(8)"
                cDefVal  := "DEFAULT '        '"
            Case cTipo == "N"
                cSqlType := "NUMERIC(" + cValToChar(nTam) + "," + cValToChar(nDec) + ")"
                cDefVal  := "DEFAULT 0"
            Case cTipo == "L"
                cSqlType := "CHAR(1)"
                cDefVal  := "DEFAULT ' '"
            Otherwise
                cSqlType := "CHAR(" + cValToChar(nTam) + ")"
                cDefVal  := "DEFAULT ''"
            EndCase
            cCreate += cField + " " + cSqlType + " NOT NULL " + cDefVal + ", "
        Next
        cCreate += "D_E_L_E_T_ CHAR(1) NOT NULL DEFAULT ' ', R_E_C_D_E_L_ INTEGER NOT NULL DEFAULT 0, R_E_C_N_O_ INTEGER IDENTITY(1,1) PRIMARY KEY)"
        TCSqlExec(cCreate)
        TCSqlExec("CREATE INDEX " + cSqlTab + "_1 ON " + cSqlTab + " (ZZL_CODFL, ZZL_FILIAL, ZZL_DESC, D_E_L_E_T_)")
    Else
        For nI := 1 To Len(aStruct)
            cField := aStruct[nI][1]
            If !MyColumnExists(cSqlTab, cField)
                cTipo := aStruct[nI][2]
                nTam  := aStruct[nI][3]
                nDec  := aStruct[nI][4]
                Do Case
                Case cTipo == "C"
                    cSqlType := "CHAR(" + cValToChar(nTam) + ")"
                Case cTipo == "D"
                    cSqlType := "CHAR(8)"
                Case cTipo == "N"
                    cSqlType := "NUMERIC(" + cValToChar(nTam) + "," + cValToChar(nDec) + ")"
                Case cTipo == "L"
                    cSqlType := "CHAR(1)"
                Otherwise
                    cSqlType := "CHAR(" + cValToChar(nTam) + ")"
                EndCase
                TCSqlExec("ALTER TABLE " + cSqlTab + " ADD " + cField + " " + cSqlType + " NULL")
            EndIf
        Next
    EndIf

    // Garante que a filial e codigo da empresa voltem para CHAR(2) caso o script antigo tenha rodado
    TCSqlExec("BEGIN TRY ALTER TABLE " + cSqlTab + " ALTER COLUMN ZZL_FILIAL CHAR(2) NOT NULL; END TRY BEGIN CATCH END CATCH")
    TCSqlExec("BEGIN TRY ALTER TABLE " + cSqlTab + " ALTER COLUMN ZZL_CODFL CHAR(2) NOT NULL; END TRY BEGIN CATCH END CATCH")

    If !MyColumnExists(cSqlTab, "D_E_L_E_T_")
        TCSqlExec("ALTER TABLE " + cSqlTab + " ADD D_E_L_E_T_ CHAR(1) NOT NULL DEFAULT ' '")
    EndIf
    If !MyColumnExists(cSqlTab, "R_E_C_D_E_L_")
        TCSqlExec("ALTER TABLE " + cSqlTab + " ADD R_E_C_D_E_L_ INTEGER NOT NULL DEFAULT 0")
    EndIf

Return

/*/{Protheus.doc} MyInsertExemplo
/*/
Static Function MyInsertExemplo(cTabela)
    Local cSqlTab := RetSqlName(cTabela)
    Local cAlias  := GetNextAlias()
    Local nCnt    := 0

    Begin Sequence
        dbUseArea(.T., "TOPCONN", TCGenQry(,, "SELECT COUNT(*) AS CNT FROM " + cSqlTab + " WHERE D_E_L_E_T_ = ' '"), cAlias, .F., .T.)
        nCnt := (cAlias)->CNT
        (cAlias)->(DbCloseArea())
    Recover
        nCnt := 0
    End Sequence

    If nCnt > 0
        Return
    EndIf

    Begin Sequence
        dbSelectArea(cTabela)
        If Select(cTabela) == 0
            DbUseArea(.T., "TOPCONN", cSqlTab, cTabela, .T., .F.)
        EndIf
        (cTabela)->(DbGoTop())
        RecLock(cTabela, .T.)
        (cTabela)->ZZL_CODFL  := "01"
        (cTabela)->ZZL_FILIAL := "01"
        (cTabela)->ZZL_DESC   := PadR("LEMBRETE EXEMPLO", 40)
        (cTabela)->ZZL_TIPO   := PadR("001", 3)
        (cTabela)->ZZL_NATURE := PadR("001", 10)
        (cTabela)->ZZL_FORN   := PadR("FOR001", 6)
        (cTabela)->ZZL_VENC   := StrZero(Day(Date()+7),2)+StrZero(Month(Date()+7),2)+cValToChar(Year(Date()+7))
        (cTabela)->ZZL_RECOR  := .F.
        (cTabela)->ZZL_AVISO  := 3
        (cTabela)->ZZL_EMAIL  := PadR("financeiro@exemplo.com.br", 50)
        (cTabela)->(MsUnlock())
    Recover
    End Sequence
Return

Static Function MyColumnExists(cSqlTab, cColumn)
    Local cAlias := GetNextAlias()
    Local lOk := .F.
    Begin Sequence
        dbUseArea(.T., "TOPCONN", TCGenQry(,, "SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = '" + cSqlTab + "' AND COLUMN_NAME = '" + cColumn + "'"), cAlias, .F., .T.)
        lOk := !(cAlias)->(Eof())
        (cAlias)->(DbCloseArea())
    Recover
        lOk := .F.
    End Sequence
Return lOk
