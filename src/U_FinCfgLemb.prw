#include "totvs.ch"
#include "fwmvcdef.ch"

/*/{Protheus.doc} FinCfgLemb
    Cadastro MVC das regras de lembretes de obrigacoes financeiras.
    Tabela: ZZL
/*/
User Function FinCfgLemb()
    Local oBrowse := Nil

    If Select("ZZL") == 0
        If FindFunction("U_UPDLEMB")
            U_UPDLEMB()
        EndIf
        ChkFile("ZZL")
    EndIf

    If Select("ZZL") == 0
        MsgStop("Nao foi possivel abrir a tabela ZZL.", "FinCfgLemb")
        Return
    EndIf

    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias("ZZL")
    oBrowse:SetDescription("Regras de Lembretes")
    oBrowse:SetMenuDef("U_FINCFGLEMB")
    oBrowse:DisableDetails()
    oBrowse:AddColumn({"Filial",     &("{|| ZZL->ZZL_FILIAL + ZZL->ZZL_CODFL}"), "C", "", 1, 4, 0, .F.})
    oBrowse:AddColumn({"Descricao",  &("{|| ZZL->ZZL_DESC}"),             "C", "@!", 1, 40, 0, .F.})
    oBrowse:AddColumn({"Tipo",       &("{|| ZZL->ZZL_TIPO}"),             "C", "@!", 1, 3,  0, .F.})
    oBrowse:AddColumn({"Natureza",   &("{|| ZZL->ZZL_NATURE}"),           "C", "@!", 1, 10, 0, .F.})
    oBrowse:AddColumn({"Fornecedor", &("{|| ZZL->ZZL_FORN}"),             "C", "@!", 1, 6,  0, .F.})
    oBrowse:AddColumn({"Vencimento", &("{|| ZZL->ZZL_VENC}"),             "C", "@R 99/99/9999", 1, 8, 0, .F.})
    oBrowse:AddColumn({"Recorrente", &("{|| IIf(ZZL->ZZL_RECOR, 'Sim', 'Nao')}"), "C", "@!", 1, 3, 0, .F.})
    oBrowse:AddColumn({"Dias Aviso", &("{|| ZZL->ZZL_AVISO}"),           "N", "99", 1, 2,  0, .F.})
    oBrowse:AddColumn({"Email",      &("{|| ZZL->ZZL_EMAIL}"),           "C", "",   1, 50, 0, .F.})
    oBrowse:Activate()

Return

Static Function MenuDef()
    Local aRotina := {}
    ADD OPTION aRotina TITLE "Pesquisar"  ACTION "PesqBrw"              OPERATION 1 ACCESS 0
    ADD OPTION aRotina TITLE "Incluir"    ACTION "VIEWDEF.U_FINCFGLEMB" OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE "Alterar"    ACTION "VIEWDEF.U_FINCFGLEMB" OPERATION 2 ACCESS 0
    ADD OPTION aRotina TITLE "Excluir"    ACTION "VIEWDEF.U_FINCFGLEMB" OPERATION 5 ACCESS 0
    ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.U_FINCFGLEMB" OPERATION 4 ACCESS 0
Return aRotina

Static Function ModelDef()
    Local oStruct  := ModelStructZZL()
    Local oModel   := Nil
    Local bLoad    := {|oFields, lCopy| LoadZZL(oFields, lCopy)}

    // Garante que ZZL esteja aberta
    If Select("ZZL") == 0
        ChkFile("ZZL")
    EndIf

    If oStruct == Nil
        MsgStop("Nao foi possivel carregar estrutura da ZZL.", "Erro MVC")
        Return Nil
    EndIf

    oModel := MPFormModel():New("FINCFGM")
    // O 6o parametro do AddFields e o bLoad (bloco de carga).
    // Evita o erro de contagem de campos do FORMLOADFIELD padrao ao Alterar/Visualizar.
    oModel:AddFields("ZZLMASTER", Nil, oStruct, Nil, Nil, bLoad)
    oModel:SetPrimaryKey({"ZZL_CODFL", "ZZL_FILIAL", "ZZL_DESC"})
    oModel:SetDescription("Configuracao de Lembretes")
    oModel:GetModel("ZZLMASTER"):SetDescription("Regras de Lembretes")
    oModel:SetCommit({|oMdl| FinCfgCommit(oMdl)})

Return oModel

/*/{Protheus.doc} LoadZZL
    Bloco de carga do formulario (bLoad do AddFields).
    Retorna array com os 10 campos na mesma ordem de ModelStructZZL.
/*/
Static Function LoadZZL(oFields, lCopy)
    Local aLoad := {}

    If Select("ZZL") > 0 .And. !ZZL->(EoF())
        AAdd(aLoad, ZZL->ZZL_CODFL)
        AAdd(aLoad, ZZL->ZZL_FILIAL)
        AAdd(aLoad, ZZL->ZZL_DESC)
        AAdd(aLoad, ZZL->ZZL_TIPO)
        AAdd(aLoad, ZZL->ZZL_NATURE)
        AAdd(aLoad, ZZL->ZZL_FORN)
        AAdd(aLoad, ZZL->ZZL_VENC)
        AAdd(aLoad, IIf(ValType(ZZL->ZZL_RECOR) == "L", ZZL->ZZL_RECOR, ZZL->ZZL_RECOR == "T"))
        AAdd(aLoad, ZZL->ZZL_AVISO)
        AAdd(aLoad, ZZL->ZZL_EMAIL)
    Else
        AAdd(aLoad, PadR(cEmpAnt, 2))
        AAdd(aLoad, PadR(cFilAnt, 2))
        AAdd(aLoad, Space(40))
        AAdd(aLoad, Space(3))
        AAdd(aLoad, Space(10))
        AAdd(aLoad, Space(6))
        AAdd(aLoad, Space(8))
        AAdd(aLoad, .F.)
        AAdd(aLoad, 0)
        AAdd(aLoad, Space(50))
    EndIf

Return aLoad

Static Function ModelStructZZL()
    Local oStruct := FWFormModelStruct():New()

    // Obrigatorio: Mapeia os campos fisicos da tabela para o modelo nao reclamar de divergencia de carga
    oStruct:AddField("Cod.Empresa", "Cod.Empresa", "ZZL_CODFL",  "C", 2, 0, Nil, Nil, Nil, .F., {|| IIf(Select("ZZL") > 0 .And. !ZZL->(EoF()), ZZL->ZZL_CODFL, Left(cEmpAnt, 2))},  .F., .T., .F.)
    oStruct:AddField("Cod.Filial",  "Cod.Filial",  "ZZL_FILIAL", "C", 2, 0, Nil, Nil, Nil, .F., {|| IIf(Select("ZZL") > 0 .And. !ZZL->(EoF()), ZZL->ZZL_FILIAL, Left(cFilAnt, 2))}, .F., .T., .F.)

    // Demais campos do cadastro que aparecem na tela (lUpdate = .T. permite alteracao)
    oStruct:AddField("Descricao",       "Descricao",       "ZZL_DESC",    "C", 40, 0, Nil, Nil, Nil, .T., {|| IIf(Select("ZZL") > 0 .And. !ZZL->(EoF()), ZZL->ZZL_DESC, "")},            .F., .T., .F.)
    oStruct:AddField("Tipo Titulo",     "Tipo Titulo",     "ZZL_TIPO",    "C", 3,  0, Nil, Nil, Nil, .F., {|| IIf(Select("ZZL") > 0 .And. !ZZL->(EoF()), ZZL->ZZL_TIPO, "")},            .F., .T., .F.)
    oStruct:AddField("Natureza",        "Natureza",        "ZZL_NATURE",  "C", 10, 0, Nil, Nil, Nil, .F., {|| IIf(Select("ZZL") > 0 .And. !ZZL->(EoF()), ZZL->ZZL_NATURE, "")},          .F., .T., .F.)
    oStruct:AddField("Fornecedor",      "Fornecedor",      "ZZL_FORN",    "C", 6,  0, Nil, Nil, Nil, .F., {|| IIf(Select("ZZL") > 0 .And. !ZZL->(EoF()), ZZL->ZZL_FORN, "")},            .F., .T., .F.)
    oStruct:AddField("Data Vencimento", "Data Vencimento", "ZZL_VENC",    "C", 8,  0, Nil, Nil, Nil, .F., {|| IIf(Select("ZZL") > 0 .And. !ZZL->(EoF()), ZZL->ZZL_VENC, "")},            .F., .T., .F.)
    oStruct:AddField("Recorrente",      "Recorrente",      "ZZL_RECOR",   "L", 1,  0, Nil, Nil, Nil, .F., {|| IIf(Select("ZZL") > 0 .And. !ZZL->(EoF()), ZZL->ZZL_RECOR, .F.)},         .F., .T., .F.)
    oStruct:AddField("Dias Aviso",      "Dias Aviso",      "ZZL_AVISO",   "N", 2,  0, Nil, Nil, Nil, .F., {|| IIf(Select("ZZL") > 0 .And. !ZZL->(EoF()), ZZL->ZZL_AVISO, 0)},            .F., .T., .F.)
    oStruct:AddField("Email Destino",   "Email Destino",   "ZZL_EMAIL",   "C", 50, 0, Nil, Nil, Nil, .F., {|| IIf(Select("ZZL") > 0 .And. !ZZL->(EoF()), ZZL->ZZL_EMAIL, "")},          .F., .T., .F.)

Return oStruct

Static Function ViewDef()
    Local oModel  := FWLoadModel("U_FINCFGLEMB")
    Local oStruct := FWFormViewStruct():New()
    Local oView   := Nil

    // Estrutura simplificada da View
    oStruct:AddField("ZZL_DESC",   "01", "Descricao",      "Descricao",      Nil, "C", "", Nil, "", .T.)
    oStruct:AddField("ZZL_TIPO",   "02", "Tipo Titulo",    "Tipo Titulo",    Nil, "C", "@!", Nil, "05", .T.)
    oStruct:AddField("ZZL_NATURE", "03", "Natureza",       "Natureza",       Nil, "C", "@!", Nil, "SED", .T.)
    oStruct:AddField("ZZL_FORN",   "04", "Fornecedor",     "Fornecedor",     Nil, "C", "", Nil, "FOR", .T.)
    oStruct:AddField("ZZL_VENC",   "05", "Data Vencimento","Data Vencimento",Nil, "C", "@R 99/99/9999", Nil, "", .T.)
    oStruct:AddField("ZZL_RECOR",  "06", "Recorrente",     "Recorrente",     Nil, "L", "", Nil, "", .T.)
    oStruct:AddField("ZZL_AVISO",  "07", "Dias Aviso",     "Dias Aviso",     Nil, "N", "99", Nil, "", .T.)
    oStruct:AddField("ZZL_EMAIL",  "08", "Email Destino",  "Email Destino",  Nil, "C", "", Nil, "", .T.)

    oView := FWFormView():New()
    oView:SetModel(oModel)
    oView:AddField("VIEW_ZZL", oStruct, "ZZLMASTER")
    oView:CreateHorizontalBox("TELA", 100)
    oView:SetOwnerView("VIEW_ZZL", "TELA")

Return oView

/*/{Protheus.doc} FinCfgCommit
    Gravação simples utilizando RecLock e xFilial
/*/
Static Function FinCfgCommit(oModel)
    Local oModelZZL  := oModel:GetModel("ZZLMASTER")
    Local nOpc       := oModel:GetOperation()
    Local lRet       := .T.

    If nOpc == 3 .Or. nOpc == 4 // Incluir ou Alterar
        
        RecLock("ZZL", (nOpc == 3))
        
        // Salva empresa e filial separadamente (padrao 2+2), juncao literal ZZL_CODFL+ZZL_FILIAL = 4 para SE2
        ZZL->ZZL_CODFL  := Left(cEmpAnt, 2)
        ZZL->ZZL_FILIAL := Left(cFilAnt, 2)
        
        // Atribuicao direta dos campos
        ZZL->ZZL_DESC   := PadR(oModelZZL:GetValue("ZZL_DESC"), 40)
        ZZL->ZZL_TIPO   := PadR(oModelZZL:GetValue("ZZL_TIPO"), 3)
        ZZL->ZZL_NATURE := PadR(oModelZZL:GetValue("ZZL_NATURE"), 10)
        ZZL->ZZL_FORN   := PadR(oModelZZL:GetValue("ZZL_FORN"), 6)
        ZZL->ZZL_VENC   := PadR(oModelZZL:GetValue("ZZL_VENC"), 8)
        ZZL->ZZL_RECOR  := oModelZZL:GetValue("ZZL_RECOR")
        ZZL->ZZL_AVISO  := oModelZZL:GetValue("ZZL_AVISO")
        ZZL->ZZL_EMAIL  := PadR(oModelZZL:GetValue("ZZL_EMAIL"), 50)
        
        ZZL->(MsUnlock())

    ElseIf nOpc == 5 // Excluir
        
        RecLock("ZZL", .F.)
        ZZL->(DbDelete())
        ZZL->(MsUnlock())
        
    EndIf

Return lRet
