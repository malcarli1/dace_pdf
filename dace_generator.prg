/*****************************************************************************
 * SISTEMA  : ROTINA EVENTUAL                                                *
 * PROGRAMA : DACE_GENERATOR.PRG                                             *
 * OBJETIVO : Gerar DACE Simplificada em PDF                                 *
 * AUTOR    : Marcelo Antonio Lázzaro Carli                                  *
 * DATA     : 15.07.2026                                                     *
 * ULT. ALT.: 15.07.2026                                                     *
 *****************************************************************************/
#include "hbzebra.ch"
#include "harupdf.ch"

Function DCe_Simplificada(cArquivo)  
   Local hPdf, hPage, nWidth, nHeight, cXml, cPdfFile

   If Empty(cArquivo) .or. !Hb_FileExists(cArquivo)
      ? [XML sem conteúdo]
      Return (Nil)
   Endif

   cXml:= Hb_MemoRead(cArquivo)

   hPdf:= HPDF_New()
   If Empty(hPdf)
      ? [Erro: Não foi possível inicializar a biblioteca HPDF (LibHaru).]
      Return (Nil)
   Endif

   HPDF_SetCompressionMode( hPdf, 15 ) // HPDF_COMP_ALL
   HPDF_SetCurrentEncoder( hPdf, "WinAnsiEncoding" )

   hPage := HPDF_AddPage( hPdf )
   HPDF_Page_SetSize( hPage, 1, 0 ) // 1 = HPDF_PAGE_SIZE_A4, 0 = HPDF_PAGE_PORTRAIT

   nWidth  := HPDF_Page_GetWidth( hPage )
   nHeight := HPDF_Page_GetHeight( hPage )

   // 1. Pinta a faixa superior inteira de cinza (Da coluna 020 até 185, Linhas 005 a 011)
   DrawSolidBox( hPage, 005, 020, 011, 185, nHeight, 0.85 )

   // 2. Desenha a moldura externa completa da DACE (A borda preta fica perfeita por cima do fundo)
   DrawRectangle( hPage, 005, 020, 130, 185, 0.4, nHeight ) 

   // 3. Escreve o texto do Cabeçalho centralizado sobre a faixa cinza
   DrawText( hPdf, hPage, 009, 105, "DACE RESUMIDA - DECLARAÇÃO AUXILIAR DE CONTEÚDO ELETRÔNICA", "Helvetica-Bold", 8.5, .T., .T., nHeight )
   
   // Demais Textos do Bloco Superior
   DrawText( hPdf, hPage, 015, 105, "Nº " + transf(Strzero(Val(XmlNode(cXml, [nDC])), 9), "@R 999.999.999") + "   SÉRIE " + Strzero(Val(XmlNode(cXml, [serie])), 3), "Helvetica-Bold", 7.5, .T., .F., nHeight )
   DrawText( hPdf, hPage, 019, 105, "DATA DE EMISSÃO: " + SubStr(XmlNode(cXml, [dhEmi]), 9, 2) + "-" + SubStr(XmlNode(cXml, [dhEmi]), 6, 2) + "-" + SubStr(XmlNode(cXml, [dhEmi]), 1, 4) + " " + SubStr(XmlNode(cXml, [dhEmi]), 12, 8), "Helvetica", 7.5, .T., .F., nHeight )
   DrawText( hPdf, hPage, 023, 105, "PROTOCOLO DE AUTORIZAÇÃO: " + XmlNode(cXml, [nProt]), "Helvetica", 7.5, .T., .F., nHeight )
   DrawText( hPdf, hPage, 027, 105, "MODALIDADE DO TRANSPORTE: " + iif( XmlNode(cXml, [modTrans]) == "0", "0-CORREIOS", iif( XmlNode(cXml, [modTrans]) == "1", "1-CONTA PROPRIA", iif( XmlNode(cXml, [modTrans]) == "2", "2-TRANSPORTADORA", XmlNode(cXml, [modTrans]) ) ) ), "Helvetica", 7.5, .T., .F., nHeight ) 

   // Dados do Remetente
   DrawText( hPdf, hPage, 035, 105, "CNPJ/CPF REMETENTE (USUÁRIO EMITENTE): " + iif( !Empty( XmlNode( XmlNode(cXml, [emit]), [CPF] ) ), Left( XmlNode( XmlNode(cXml, [emit]), [CPF] ), 3 ) + ".******-" + Right( XmlNode( XmlNode(cXml, [emit]), [CPF] ), 2 ), iif( !Empty( XmlNode( XmlNode(cXml, [emit]), [CNPJ] ) ), Trans( XmlNode( XmlNode(cXml, [emit]), [CNPJ] ), "@R 99.999.999/9999-99" ), "" ) ), "Helvetica", 7.5, .T., .F., nHeight )
   DrawText( hPdf, hPage, 039, 105, "NOME REMETENTE: " + XmlNode(XmlNode(cXml, [emit]), [xNome]), "Helvetica", 7.5, .T., .F., nHeight )
   DrawText( hPdf, hPage, 043, 105, "CIDADE-UF REMETENTE: " + XmlNode(XmlNode(cXml, [emit]), [xMun]) + [ - ] + XmlNode(XmlNode(cXml, [emit]), [UF]), "Helvetica", 7.5, .T., .F., nHeight )
   DrawText( hPdf, hPage, 047, 105, "ENDEREÇO REMETENTE: " + XmlNode(XmlNode(cXml, [emit]), [xLgr]) + [, ] + XmlNode(XmlNode(cXml, [emit]), [nro]) + [ ] + XmlNode(XmlNode(cXml, [emit]), [xCpl]) + [ ] + XmlNode(XmlNode(cXml, [emit]), [xBairro]) + [ - CEP: ] + XmlNode(XmlNode(cXml, [emit]), [CEP]), "Helvetica", 7.5, .T., .F., nHeight )

   // Dados do Destinatário
   DrawText( hPdf, hPage, 055, 105, "CNPJ/CPF DESTINATÁRIO: " + iif( !Empty( XmlNode( XmlNode(cXml, [dest]), [CPF] ) ), Left( XmlNode( XmlNode(cXml, [dest]), [CPF] ), 3 ) + ".***.***-" + Right( XmlNode( XmlNode(cXml, [dest]), [CPF] ), 2 ), iif( !Empty( XmlNode( XmlNode(cXml, [dest]), [CNPJ] ) ), Transf( XmlNode( XmlNode(cXml, [dest]), [CNPJ] ), "@R 99.999.999/9999-99" ), "" ) ), "Helvetica", 7.5, .T., .F., nHeight )
   DrawText( hPdf, hPage, 059, 105, "NOME DESTINATÁRIO: " + XmlNode(XmlNode(cXml, [dest]), [xNome]), "Helvetica", 7.5, .T., .F., nHeight )
   DrawText( hPdf, hPage, 063, 105, "CIDADE-UF DESTINATÁRIO: " + XmlNode(XmlNode(cXml, [dest]), [xMun]) + [ - ] + XmlNode(XmlNode(cXml, [dest]), [UF]), "Helvetica", 7.5, .T., .F., nHeight )
   DrawText( hPdf, hPage, 067, 105, "ENDEREÇO DESTINATÁRIO: " + XmlNode(XmlNode(cXml, [dest]), [xLgr]) + [, ] + XmlNode(XmlNode(cXml, [dest]), [nro]) + [ ] + XmlNode(XmlNode(cXml, [dest]), [xCpl]) + [ ] + XmlNode(XmlNode(cXml, [dest]), [xBairro]) + [ - CEP: ] + XmlNode(XmlNode(cXml, [dest]), [CEP]), "Helvetica", 7.5, .T., .F., nHeight )
  
    // Dados do Fisco / Marketplace
   DrawText( hPdf, hPage, 075, 105, "CNPJ FISCO/ MARKETPLACE/ TRANSPORTADOR: " + XmlNode(XmlNode(cXml, [Marketplace]), [CNPJ]), "Helvetica", 7.5, .T., .F., nHeight )
   DrawText( hPdf, hPage, 079, 105, "NOME FISCO/ MARKETPLACE/ TRANSPORTADOR: " + XmlNode(XmlNode(cXml, [Marketplace]), [xNome]), "Helvetica", 7.5, .T., .F., nHeight )

   HPDFDrawBarcode( hPdf, hPage, nHeight, 085, 25,XmlNode(XmlNode(cXml, [infDCeSupl]), [qrCodDCe]), "QRCODE", 2.5 )

   // Bloco 1 - Primeira observação (xObs1) - Convertendo de UTF-8 para PTISO (ANSI)
   DrawText( hPdf, hPage, 085, 060, hb_UTF8ToStr(XmlNode(XmlNode(cXml, [infDec]), [xObs1]), "PTISO"), "Helvetica", 7.5, .F., .F., nHeight, 100, 180, .T. )
   
   // Bloco 2 - Segunda observação (xObs2) - Convertendo de UTF-8 para PTISO (ANSI)
   DrawText( hPdf, hPage, 100, 060, hb_UTF8ToStr(XmlNode(XmlNode(cXml, [infDec]), [xObs2]), "PTISO"), "Helvetica", 7.5, .F., .F., nHeight, 125, 180, .T. )

   // Chave de Acesso no rodapé
   DrawText( hPdf, hPage, 122, 105, "Chave de Acesso DC-e", "Helvetica-Bold", 8.5, .T., .F., nHeight )
   DrawText( hPdf, hPage, 127, 105, Transf(XmlNode(cXml, [chDCe]), "@R 9999 9999 9999 9999 9999 9999 9999 9999 9999 9999 9999"), "Helvetica-Bold", 8.5, .T., .T., nHeight )

   // Salva e fecha o documento PDF
   cPdfFile:= "DACE_Resumida_" + XmlNode(cXml, [nDC]) + ".pdf"
   HPDF_SaveToFile( hPdf, cPdfFile )
   HPDF_Free( hPdf )
   
   // Retorno operacional padrão
   If Hb_FileExists(cPdfFile)
      ? "Arquivo PDF da DACE gerado com sucesso!" + hb_Eol() + "Nome do arquivo: " + cPdfFile, "Sucesso"
      WAPI_SHELLEXECUTE(cPdfFile,, cPdfFile,,, 1)
   Else
      ? "Erro de Gravação: Não foi possível gerar o arquivo " + cPdfFile, "Erro"
   Endif
Return (Nil)

// =========================================================================
// FUNÇÕES AUXILIARES DE TRADUÇÃO DE COORDENADAS E DESENHO
// =========================================================================

Static Function MM_X( nCol )
Return nCol * 2.834645669

Static Function MM_Y( nRow, nHeight )
Return nHeight - ( nRow * 2.834645669 )

// NOVO: Desenha um retângulo preenchido (Para fazer a faixa cinza de cabeçalho)
Static Procedure DrawFilledRectangle( hPage, nRow1, nCol1, nRow2, nCol2, nPenWidth, nHeight, nGray )
   Local x1 := MM_X( nCol1 )
   Local y1 := MM_Y( nRow1, nHeight )
   Local x2 := MM_X( nCol2 )
   Local y2 := MM_Y( nRow2, nHeight )
   Local nX := Min( x1, x2 )
   Local nY := Min( y1, y2 )
   Local nW := Abs( x2 - x1 )
   Local nH := Abs( y2 - y1 )
   
   HPDF_Page_SetLineWidth( hPage, nPenWidth )
   
   // Define a cor de preenchimento (0.0 = preto / 1.0 = branco / 0.85 = cinza suave)
   HPDF_Page_SetGrayFill( hPage, nGray )
   
   // Garante que a borda continue sendo desenhada em preto puro (0.0)
   HPDF_Page_SetGrayStroke( hPage, 0.0 )
   
   HPDF_Page_Rectangle( hPage, nX, nY, nW, nH )
   
   // FillStroke: Aplica o preenchimento (cinza) e desenha o contorno (preto) simultaneamente
   HPDF_Page_FillStroke( hPage )
   
   // IMPORTANTÍSSIMO: Reseta a cor de preenchimento padrão para preto para não afetar os textos seguintes
   HPDF_Page_SetGrayFill( hPage, 0.0 )
Return

// Desenha retângulos sem preenchimento
Static Procedure DrawRectangle( hPage, nRow1, nCol1, nRow2, nCol2, nPenWidth, nHeight )
   Local x1 := MM_X( nCol1 )
   Local y1 := MM_Y( nRow1, nHeight )
   Local x2 := MM_X( nCol2 )
   Local y2 := MM_Y( nRow2, nHeight )
   Local nX := Min( x1, x2 )
   Local nY := Min( y1, y2 )
   Local nW := Abs( x2 - x1 )
   Local nH := Abs( y2 - y1 )
   
   HPDF_Page_SetLineWidth( hPage, nPenWidth )
   HPDF_Page_Rectangle( hPage, nX, nY, nW, nH )
   HPDF_Page_Stroke( hPage )
Return

// Escreve textos (Simples, Centralizados, Em Bloco ou Justificados) usando LibHaru puro
Static Procedure DrawText( hPdf, hPage, nRow, nCol, cText, cFontName, nSize, lCenter, lBold, nHeight, nRow2, nCol2, lJustify )
   Local hFont
   Local x := MM_X( nCol )
   Local y := MM_Y( nRow, nHeight )
   Local x2, y2

   hb_Default( @lCenter, .F. )
   hb_Default( @lBold, .F. )
   hb_Default( @lJustify, .F. )

   If lBold .and. !("Bold" $ cFontName)
      cFontName += "-Bold"
   Endif

   hFont := HPDF_GetFont( hPdf, cFontName, "WinAnsiEncoding" )
   HPDF_Page_SetFontAndSize( hPage, hFont, nSize )

   If nRow2 # Nil .and. nCol2 # Nil
      x2 := MM_X( nCol2 )
      y2 := MM_Y( nRow2, nHeight )
      HPDF_Page_BeginText( hPage )
      HPDF_Page_TextRect( hPage, Min(x, x2), Max(y, y2), Max(x, x2), Min(y, y2), cText, iif( lJustify, HPDF_TALIGN_JUSTIFY, HPDF_TALIGN_LEFT ), Nil )
      HPDF_Page_EndText( hPage )
   Else
      HPDF_Page_BeginText( hPage )
      If lCenter
         HPDF_Page_TextOut( hPage, x - ( HPDF_Page_TextWidth( hPage, cText ) / 2 ), y, cText )
      Else
         HPDF_Page_TextOut( hPage, x, y, cText )
      Endif
      HPDF_Page_EndText( hPage )
   Endif
Return

// =========================================================================
// FUNÇÕES DE IMPRESSÃO DE CÓDIGOS DE BARRA / QR-CODE (HB_ZEBRA EM HPDF)
// =========================================================================
Static Procedure HPDFDrawBarcode( hPdf, hPage, nHeight, nRow, nCol, cCode, cType, nLineWidth, nLineHeight, lShowDigits, lCheckSum, lWide2_5, lWide3 )
   Local hZebra, cTxt, nSizeWidth, nSizeHeight, nTextWidth, nFontSize:= 9, nTextHeight:= nFlags:= 0, cFont:= "Helvetica"
   Local nxPos  := MM_X( nCol )
   Local nyPos  := MM_Y( nRow, nHeight )

   hb_Default(@lShowDigits, .F.)
   hb_Default(@nLineHeight, 18)
   hb_Default(@nLineWidth, 1)
   hb_Default(@lCheckSum, .F.)
   hb_Default(@lWide2_5, .F.)
   hb_Default(@lWide3, .F.)
 
   If lChecksum
      nFlags:= nFlags + HB_ZEBRA_FLAG_CHECKSUM
   Endif
   If lWide2_5
      nFlags:= nFlags + HB_ZEBRA_FLAG_WIDE2_5
   Endif
   If lWide3
      nFlags:= nFlags + HB_ZEBRA_FLAG_WIDE3
   Endif
      
   If nFlags == 0
      nFlags:= Nil
   Endif

   SWITCH cType
      Case "EAN13"      ; hZebra := hb_zebra_create_ean13(cCode, nFlags)      ; EXIT
      Case "EAN8"       ; hZebra := hb_zebra_create_ean8(cCode, nFlags)       ; EXIT
      Case "UPCA"       ; hZebra := hb_zebra_create_upca(cCode, nFlags)       ; EXIT 
      Case "UPCE"       ; hZebra := hb_zebra_create_upce(cCode, nFlags)       ; EXIT
      Case "CODE39"     ; hZebra := hb_zebra_create_code39(cCode, nFlags)     ; EXIT
      Case "ITF"        ; hZebra := hb_zebra_create_itf(cCode, nFlags)        ; EXIT
      Case "MSI"        ; hZebra := hb_zebra_create_msi(cCode, nFlags)        ; EXIT
      Case "CODABAR"    ; hZebra := hb_zebra_create_codabar(cCode, nFlags)    ; EXIT
      Case "CODE93"     ; hZebra := hb_zebra_create_code93(cCode, nFlags)     ; EXIT
      Case "CODE11"     ; hZebra := hb_zebra_create_code11(cCode, nFlags)     ; EXIT
      Case "CODE128"    ; hZebra := hb_zebra_create_code128(cCode, nFlags)    ; EXIT
      Case "PDF417"     ; hZebra := hb_zebra_create_pdf417(cCode, nFlags)     ; nLineHeight:= nLineWidth * 3 ; lShowDigits:= .F. ; EXIT
      Case "DATAMATRIX" ; hZebra := hb_zebra_create_datamatrix(cCode, nFlags) ; nLineHeight:= nLineWidth     ; lShowDigits:= .F. ; EXIT
      Case "QRCODE"     ; hZebra := hb_zebra_create_qrcode(cCode, nFlags)     ; nLineHeight:= nLineWidth     ; lShowDigits:= .F. ; EXIT
   ENDSWITCH

   If hZebra # Nil
      If hb_zebra_geterror(hZebra) == 0
         If lShowDigits
            cTxt        := AllTrim(hb_zebra_getcode(hZebra))
            nSizeWidth := HMGZebra_GetWidth  (hZebra, nLineWidth, nLineHeight, Nil)
            nSizeHeight:= HMGZebra_GetHeight (hZebra, nLineWidth, nLineHeight, Nil)
            
            HPDF_Page_SetFontAndSize(hPage, HPDF_GetFont(hPdf, cFont, Nil), nFontSize)
            nTextWidth := HPDF_Page_TextWidth(hPage, cTxt)
            nTextHeight:= nFontSize - 1
            HPDF_Page_BeginText(hPage)
            HPDF_Page_TextOut(hPage, (nxPos + (nSizeWidth / 2)) - (nTextWidth / 2), nyPos - nSizeHeight, cTxt)
            HPDF_Page_EndText(hPage)         
         Endif
         
         hb_zebra_draw_hpdf(hZebra, hPage, nxPos, nyPos, nLineWidth, -(nLineHeight - nTextHeight))
      ELSE
         ? "Tipo " + cType + hb_Eol() + "Code " + cCode + hb_Eol() + "Erro  " + LTrim(hb_valtostr(hb_zebra_geterror(hZebra)))
      Endif
      hb_zebra_destroy(hZebra)
   Else
      ? "Inválido Tipo de Código de Barra!", cType
   Endif
Return (Nil)

Static Function hb_zebra_draw_hpdf(hZebra, hPage, ...)
   If hb_zebra_geterror(hZebra) # 0
      Return (3) // HB_ZEBRA_ERROR_INVALIDZEBRA
   Endif
   hb_zebra_draw(hZebra, {| x, y, w, h | HPDF_Page_Rectangle(hPage, x, y, w, h)}, ...)
   HPDF_Page_Fill(hPage)
Return (0)

Static Function HMGZebra_GetWidth (hZebra, nLineWidth, nLineHeight, iFlags)
   Local x1:= y1:= nBarWidth:= nBarHeight:= 0
   If hb_zebra_GetError(hZebra) # 0
      Return (3)
   Endif
   hb_zebra_draw (hZebra, {| x, y, w, h | nBarWidth:= Max(x + w - x1, nBarWidth), nBarHeight:= y + h - y1}, x1, y1, nLineWidth, nLineHeight, iFlags)
Return (nBarWidth)

Static Function HMGZebra_GetHeight (hZebra, nLineWidth, nLineHeight, iFlags)
   Local x1:= y1:= nBarWidth:= nBarHeight:= 0
   If hb_zebra_GetError(hZebra) # 0
      Return (3)
   Endif
   hb_zebra_draw (hZebra, {| x, y, w, h | nBarWidth:= x + w - x1, nBarHeight:= y + h - y1}, x1, y1, nLineWidth, nLineHeight, iFlags)
Return (nBarHeight)

// Desenha o texto já com uma caixinha cinza de fundo calculada automaticamente
Static Procedure DrawTextWithHighlight( hPdf, hPage, nRow, nCol, cText, cFontName, nSize, lCenter, nHeight, nGray )
   Local hFont
   Local x := MM_X( nCol )
   Local y := MM_Y( nRow, nHeight )
   Local nTextWidth, nTextHeight
   
   hFont := HPDF_GetFont( hPdf, cFontName, "WinAnsiEncoding" )
   HPDF_Page_SetFontAndSize( hPage, hFont, nSize )
   
   // Mede a largura exata do texto em pontos de PDF
   nTextWidth  := HPDF_Page_TextWidth( hPage, cText )
   nTextHeight := nSize * 1.25 // Define uma altura proporcional ao tamanho da fonte
   
   If lCenter
      x := x - ( nTextWidth / 2 )
   Endif

   // 1. Desenha o fundo cinza ajustado ao tamanho do texto (com margem de 2 pontos de respiro)
   HPDF_Page_SetGrayFill( hPage, nGray )
   HPDF_Page_Rectangle( hPage, x - 2, y - 2, nTextWidth + 4, nTextHeight )
   HPDF_Page_Fill( hPage )
   
   // 2. Escreve o texto em preto por cima do fundo cinza
   HPDF_Page_SetGrayFill( hPage, 0.0 )
   HPDF_Page_BeginText( hPage )
   HPDF_Page_TextOut( hPage, x, y, cText )
   HPDF_Page_EndText( hPage )
Return

// Desenha um bloco de preenchimento sólido (sem bordas), ideal para fundos (backgrounds)
Static Procedure DrawSolidBox( hPage, nRow1, nCol1, nRow2, nCol2, nHeight, nGray )
   Local x1 := MM_X( nCol1 )
   Local y1 := MM_Y( nRow1, nHeight )
   Local x2 := MM_X( nCol2 )
   Local y2 := MM_Y( nRow2, nHeight )
   Local nX := Min( x1, x2 )
   Local nY := Min( y1, y2 )
   Local nW := Abs( x2 - x1 )
   Local nH := Abs( y2 - y1 )
   
   // Define a cor de preenchimento (0.85 = cinza claro padrão)
   HPDF_Page_SetGrayFill( hPage, nGray )
   
   // Cria a área do retângulo
   HPDF_Page_Rectangle( hPage, nX, nY, nW, nH )
   
   // Aplica apenas o preenchimento (Fill) sem desenhar contornos
   HPDF_Page_Fill( hPage )
   
   // Retorna a cor de preenchimento para preto (0.0) para não afetar os próximos textos
   HPDF_Page_SetGrayFill( hPage, 0.0 )
Return

Static Function XmlNode( cXml, cNode, lComTag )

   LOCAL nStart, nEnd, cResult := ""
   LOCAL nStart2

   hb_Default( @lComTag, .F. )
   nStart  := At( "<" + cNode + ">", cXml )
   nStart2 := At( "<" + cNode + " ", cXml )
   IF nStart == 0
      nStart := nStart2
   ELSEIF nStart2 != 0 .AND. nStart2 < nStart
      nStart := nStart2
   ENDIF
   // after to get nStart or fail
   IF " " $ cNode
      cNode := Substr( cNode, 1, At( " ", cNode ) - 1 )
   ENDIF
   IF nStart != 0
      IF ! lComTag
         nStart := nStart + Len( cNode ) + 2
         IF nStart != 1 .AND. Substr( cXml, nStart - 1, 1 ) != ">" // when have elements on block
            nStart := hb_At( ">", cXml, nStart ) + 1
         ENDIF
      ENDIF
      nEnd := hb_At( "</" + cNode + ">", cXml, nStart )
      IF nEnd != 0
         nEnd -=1
         IF lComTag
            nEnd := nEnd + Len( cNode ) + 3
         ENDIF
         cResult := Substr( cXml, nStart, nEnd - nStart + 1 )
      ENDIF
   ENDIF

   RETURN cResult