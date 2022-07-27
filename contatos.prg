SetMode(25,80)
set epoch to 1930
set date British
set century on
set wrap on
set scoreboard off
set color to GR+/BG
clear

//-----------------------------------------------------------------------------
// Interface
//-----------------------------------------------------------------------------
@ 00,01 to 23,77 double

@ 01,03 say "Sistema de Contatos"

//-----------------------------------------------------------------------------
// Variáveis
//-----------------------------------------------------------------------------
cLoginSalvo := Space(0)
cSenhaSalva := Space(0)
cContato1   := Space(0)
cContato2   := Space(0)
cContato3   := Space(0)
cContato4   := Space(0)
cContato5   := Space(0)
cSimbolo    := "  "
cNumericos  := "1234567890"
cMinusculos := "abcdefghijklmnopqrstuvwxyz"
cMaiusculos := "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

do while .t.
   @ 03,03 clear to 22,76
   cLogin             := Space(30)
   cSenha             := Space(30)
   cLetra             := Space(0)
   cLoginErro         := Space(0)
   nMaiusculasSenha   := 0
   lVoltarLogin       := .f.
   nSairPrograma      := 0
   // Condições da senha
   lPossuiNumerico    := .f.
   lPossui2Maiusculas := .f.
   lPossui1Minuscula  := .f.
   //--------------------------------------------------------------------------
   // Tela de Login
   //--------------------------------------------------------------------------
   @ 03,03 say "Login:"
   @ 04,03 say "Senha:"

   @ 03,10 get cLogin picture "@!" valid !Empty(cLogin)
   @ 04,10 get cSenha              valid !Empty(cSenha)
   read

   if lastkey() == 27
      nSairPrograma := Alert("Deseja encerrar o programa?", {"Sim", "Nao"}, "G/N")
      if nSairPrograma == 1
         exit
      else
         loop
      endif
   endif

   cLogin := Alltrim(cLogin)
   cSenha := Alltrim(cSenha)

   if Empty(cLoginSalvo)
      nContador := 0

      if Len(cSenha) < 8
         cLoginErro := "A senha precisa ter no minimo 8 caracteres."

      elseif "123" $ cSenha
         cLoginErro := "A senha nao pode conter a sequencia '123'."

      elseif cLogin $ cSenha
         cLoginErro := "A senha nao pode conter o login."

      endif

      if !Empty(cLoginErro)
         Alert(cLoginErro, , "G/N")
         loop
      endif

      // Verificando letra por letra
      do while nContador++ < Len(cSenha)
         cLetra := SubStr(cSenha, nContador, 1)

         if cLetra $ cNumericos
            lPossuiNumerico := .t.
         endif

         if cLetra $ cMaiusculos
            nMaiusculasSenha++
            if nMaiusculasSenha >= 2
               lPossui2Maiusculas := .t.
            endif
         endif

         if cLetra $ cNumericos
            lPossui1Minuscula := .t.
         endif

      enddo

      if !lPossuiNumerico
         cLoginErro := "A senha deve possuir ao menos um numerico."

      elseif !lPossui2Maiusculas
         cLoginErro := "A senha deve possuir ao menos duas letras maiusculas."

      elseif !lPossui1Minuscula
         cLoginErro := "A senha deve possuir ao menos uma letra minuscula."

      endif

      if !Empty(cLoginErro)
         Alert(cLoginErro, , "G/N")
         loop
      endif

      // Salvando login e senha
      cLoginSalvo := cLogin
      cSenhaSalva := cSenha

   elseif cLogin != cLoginSalvo .or. cSenha != cSenhaSalva
      Alert("Login ou senha incorretos!",, "G/N")
      loop

   endif

   //--------------------------------------------------------------------------
   // Solicitando código do contato
   //--------------------------------------------------------------------------
   @ 03,03 clear to 03,76

   @ 03,03 say "Codigo do contato:"

   do while .t.
      @ 04,03 clear to 22,76

      nContatoCodigo := 0

      @ 03,22 get nContatoCodigo picture "9" valid Str(nContatoCodigo) $ "12345"
      read

      if lastkey() == 27
         lVoltarLogin := .t.
         exit
      endif

      cNome         := Space(50)
      cFone         := Space(14)
      cSexo         := Space(01)
      cEndereco     := Space(30)
      cCidade       := Space(20)
      dNascimento   := ctod("")
      nIdade        := 0
      nAltura       := 0
      nNumero       := 0
      nVoltarCodigo := 0

      if nContatoCodigo == 1
         cContato := cContato1

      elseif nContatoCodigo == 2
         cContato := cContato2

      elseif nContatoCodigo == 3
         cContato := cContato3

      elseif nContatoCodigo == 4
         cContato := cContato4

      else
         cContato := cContato5
      endif

      if Empty(cContato)
         //--------------------------------------------------------------------
         // NOVO CONTATO
         @ 05,03 say "Nome......:"
         @ 06,03 say "Telefone..:"
         @ 07,03 say "Nascimento:"
         @ 08,03 say "Idade.....:"
         @ 09,03 say "Sexo (F/M):"
         @ 10,03 say "Altura (M):"
         @ 11,03 say "Endereco..:"
         @ 12,03 say "Numero....:"
         @ 13,03 say "Cidade....:"

         do while .t.
            @ 05,15 get cNome        picture "@!"       valid !Empty(cNome)
            @ 06,15 get cFone        picture "@!"       valid !Empty(cFone)
            @ 07,15 get dNascimento                     valid !Empty(dNascimento)
            @ 08,15 get nIdade       picture "999"      valid nIdade > 0
            @ 09,15 get cSexo        picture "@!"       valid cSexo $ "FM"
            @ 10,15 get nAltura      picture "9.99"     valid nAltura > 0
            @ 11,15 get cEndereco    picture "@!"       valid !Empty(cEndereco)
            @ 12,15 get nNumero      picture "99999999" valid nNumero > 0
            @ 13,15 get cCidade      picture "@!"       valid !Empty(cCidade)
            read

            if lastkey() == 27
               nVoltarCodigo := Alert("Deseja voltar a selecao de codigos?", {"Sim", "Nao"}, "G/N")

               if nVoltarCodigo == 1
                  exit
               else
                  loop
               endif

            endif

            exit
         enddo

         if nVoltarCodigo == 1
            loop
         endif

         //--------------------------------------------------------------------
         // SALVANDO DADOS DO CONTATO

         // Removendo espacos vazios do começo e fim das strings
         cNome       := Alltrim(cNome)
         cFone       := Alltrim(cFone)
         cNascimento := dtoc(dNascimento)
         cIdadeStr   := Alltrim(Str(nIdade))
         cAltura     := Alltrim(Str(nAltura))
         cEndereco   := Alltrim(cEndereco)
         cNumero     := Alltrim(Str(nNumero))
         cCidade     := Alltrim(cCidade)

         // Removendo simbolo de possiveis candidatos
         do while cSimbolo $ cNome
            nAt   := At(cSimbolo, cNome)
            cNome := SubStr(cNome, 0, nAt-1) + SubStr(cNome, nAt+1, Len(cNome)-nAt)
         enddo

         do while cSimbolo $ cFone
            nAt   := At(cSimbolo, cFone)
            cFone := SubStr(cFone, 0, nAt-1) + SubStr(cFone, nAt+1, Len(cFone)-nAt)
         enddo

         do while cSimbolo $ cEndereco
            nAt   := At(cSimbolo, cEndereco)
            cFone := SubStr(cEndereco, 0, nAt-1) + SubStr(cEndereco, nAt+1, Len(cEndereco)-nAt)
         enddo

         do while cSimbolo $ cCidade
            nAt   := At(cSimbolo, cCidade)
            cFone := SubStr(cCidade, 0, nAt-1) + SubStr(cCidade, nAt+1, Len(cCidade)-nAt)
         enddo

         cContato := cNome + cSimbolo + cFone   + cSimbolo + cNascimento + cSimbolo + cIdadeStr + cSimbolo
         cContato += cSexo + cSimbolo + cAltura + cSimbolo + cEndereco   + cSimbolo + cNumero   + cSimbolo + cCidade + cSimbolo

         if nContatoCodigo == 1
            cContato1 := cContato

         elseif nContatoCodigo == 2
            cContato2 := cContato

         elseif nContatoCodigo == 3
            cContato3 := cContato

         elseif nContatoCodigo == 4
            cContato4 := cContato

         else
            cContato5 := cContato
         endif

         Alert("Contato adicionado com sucesso!", , "G/N")

      else
         //--------------------------------------------------------------------
         // CONTATO JÁ EXISTENTE
         nContatoExistente := Alert("Contato ja existente, o que deseja fazer?", {"Acessa-lo", "Exclui-lo"}, "G/N")

         if nContatoExistente == 0
            loop
         endif

         if nContatoExistente == 2

            if nContatoCodigo == 1
               cContato1 := Space(0)

            elseif nContatoCodigo == 2
               cContato2 := Space(0)

            elseif nContatoCodigo == 3
               cContato3 := Space(0)

            elseif nContatoCodigo == 4
               cContato4 := Space(0)

            else
               cContato5 := Space(0)
            endif

            Alert("Contato excluido com sucesso.", , "G/N")
            loop
         endif

         // Carregando dados salvos
         nContador := 0
         do while nContador++ < 9
            nAt := At(cSimbolo, cContato)
            if nContador == 1
               cNome := SubStr(cContato, 0, nAt-1)
               cNome += Replicate(" ", 50-Len(cNome))

            elseif nContador == 2
               cFone := SubStr(cContato, 0, nAt-1)
               cFone += Replicate(" ", 14-Len(cFone))

            elseif nContador == 3
               dNascimento := ctod(SubStr(cContato, 0, nAt-1))

            elseif nContador == 4
               nIdade := Val(SubStr(cContato, 0, nAt-1))

            elseif nContador == 5
               cSexo := SubStr(cContato, 0, nAt-1)

            elseif nContador == 6
               nAltura := Val(SubStr(cContato, 0, nAt-1))

            elseif nContador == 7
               cEndereco := SubStr(cContato, 0, nAt-1)
               cEndereco += Replicate(" ", 30-Len(cEndereco))

            elseif nContador == 8
               nNumero := Val(SubStr(cContato, 0, nAt-1))

            elseif nContador == 9
               cCidade := SubStr(cContato, 0, nAt-1)
               cCidade += Replicate(" ", 20-Len(cCidade))

            endif

            cContato  := SubStr(cContato, nAt+2, Len(cContato)-nAt-1)
         enddo

         nVoltarCodigo := 0

         //--------------------------------------------------------------------
         // EDITANDO CONTATO
         @ 05,03 say "Nome......:"
         @ 06,03 say "Telefone..:"
         @ 07,03 say "Nascimento:"
         @ 08,03 say "Idade.....:"
         @ 09,03 say "Sexo (F/M):"
         @ 10,03 say "Altura (M):"
         @ 11,03 say "Endereco..:"
         @ 12,03 say "Numero....:"
         @ 13,03 say "Cidade....:"

         do while .t.
            @ 05,15 get cNome        picture "@!"       valid !Empty(cNome)
            @ 06,15 get cFone        picture "@!"       valid !Empty(cFone)
            @ 07,15 get dNascimento                     valid !Empty(dNascimento)
            @ 08,15 get nIdade       picture "999"      valid nIdade > 0
            @ 09,15 get cSexo        picture "@!"       valid cSexo $ "FM"
            @ 10,15 get nAltura      picture "9.99"     valid nAltura > 0
            @ 11,15 get cEndereco    picture "@!"       valid !Empty(cEndereco)
            @ 12,15 get nNumero      picture "99999999" valid nNumero > 0
            @ 13,15 get cCidade      picture "@!"       valid !Empty(cCidade)
            read

            if lastkey() == 27
               nVoltarCodigo := Alert("Deseja voltar a selecao de codigos?", {"Sim", "Nao"}, "G/N")

               if nVoltarCodigo == 1
                  exit
               else
                  loop
               endif

            endif

            exit
         enddo

         if nVoltarCodigo == 1
            loop
         endif

         //--------------------------------------------------------------------
         // SALVANDO DADOS DO CONTATO

         // Removendo espacos vazios do começo e fim das strings
         cNome       := Alltrim(cNome)
         cFone       := Alltrim(cFone)
         cNascimento := dtoc(dNascimento)
         cIdadeStr   := Alltrim(Str(nIdade))
         cAltura     := Alltrim(Str(nAltura))
         cEndereco   := Alltrim(cEndereco)
         cNumero     := Alltrim(Str(nNumero))
         cCidade     := Alltrim(cCidade)

         // Removendo simbolo de possiveis candidatos
         do while cSimbolo $ cNome
            nAt   := At(cSimbolo, cNome)
            cNome := SubStr(cNome, 0, nAt-1) + SubStr(cNome, nAt+1, Len(cNome)-nAt)
         enddo

         do while cSimbolo $ cFone
            nAt   := At(cSimbolo, cFone)
            cFone := SubStr(cFone, 0, nAt-1) + SubStr(cFone, nAt+1, Len(cFone)-nAt)
         enddo

         do while cSimbolo $ cEndereco
            nAt   := At(cSimbolo, cEndereco)
            cFone := SubStr(cEndereco, 0, nAt-1) + SubStr(cEndereco, nAt+1, Len(cEndereco)-nAt)
         enddo

         do while cSimbolo $ cCidade
            nAt   := At(cSimbolo, cCidade)
            cFone := SubStr(cCidade, 0, nAt-1) + SubStr(cCidade, nAt+1, Len(cCidade)-nAt)
         enddo

         cContato := cNome + cSimbolo + cFone   + cSimbolo + cNascimento + cSimbolo + cIdadeStr + cSimbolo
         cContato += cSexo + cSimbolo + cAltura + cSimbolo + cEndereco   + cSimbolo + cNumero   + cSimbolo + cCidade + cSimbolo

         if nContatoCodigo == 1
            cContato1 := cContato

         elseif nContatoCodigo == 2
            cContato2 := cContato

         elseif nContatoCodigo == 3
            cContato3 := cContato

         elseif nContatoCodigo == 4
            cContato4 := cContato

         else
            cContato5 := cContato
         endif

         Alert("Contato editado com sucesso!", , "G/N")

      endif

   enddo

   if lVoltarLogin
      loop
   endif

enddo
