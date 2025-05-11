       IDENTIFICATION DIVISION.
       PROGRAM-ID. EXTR001.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.

       DATA DIVISION.
       WORKING-STORAGE SECTION.

       EXEC SQL INCLUDE SQLCA END-EXEC.

       01 WS-CONTA         PIC X(10).
       01 WS-IDX           PIC S9(4) COMP.
       01 WS-MAX           PIC S9(4) COMP VALUE 10.

       01 WS-EXTRATO.
          05 WS-DATA       PIC X(10).
          05 WS-DESC       PIC X(100).
          05 WS-VALOR      PIC S9(9)V99.

       01 TABELA-EXTRATO.
          05 WS-LINHAS      OCCURS 0 TO 10 TIMES
                            DEPENDING ON WS-MAX
                            INDEXED BY WS-IDX.
             10 T-DATA      PIC X(10).
             10 T-DESC      PIC X(100).
             10 T-VALOR     PIC S9(9)V99.

       EXEC SQL
          BEGIN DECLARE SECTION
       END-EXEC.
       01 :CONTA-IN         PIC X(10).
       01 :DATA-OUT         DATE.
       01 :DESC-OUT         VARCHAR(100).
       01 :VALOR-OUT        DECIMAL(15,2).
       EXEC SQL
          END DECLARE SECTION
       END-EXEC.

       PROCEDURE DIVISION.

       MAIN-LOGIC SECTION.

           MOVE '1234567890' TO :CONTA-IN.

           EXEC SQL
               DECLARE CURSOR_EXTRATO CURSOR FOR
               SELECT DATA, DESCRICAO, VALOR
               FROM EXTRATOS
               WHERE CONTA = :CONTA-IN
               ORDER BY DATA DESC
           END-EXEC.

           EXEC SQL
               OPEN CURSOR_EXTRATO
           END-EXEC.

           SET WS-IDX TO 1

           PERFORM UNTIL SQLCODE NOT = 0 OR WS-IDX > WS-MAX
               EXEC SQL
                   FETCH CURSOR_EXTRATO INTO :DATA-OUT, :DESC-OUT, :VALOR-OUT
               END-EXEC

               IF SQLCODE = 0 THEN
                   MOVE FUNCTION DATE-OF-INTEGER(DATE-OUT) TO T-DATA(WS-IDX)
                   MOVE DESC-OUT TO T-DESC(WS-IDX)
                   MOVE VALOR-OUT TO T-VALOR(WS-IDX)
                   SET WS-IDX UP BY 1
               END-IF
           END-PERFORM.

           EXEC SQL
               CLOSE CURSOR_EXTRATO
           END-EXEC.

           EXEC CICS RETURN
                TRANSID('EXT1')
                COMMAREA(TABELA-EXTRATO)
                LENGTH(LENGTH OF TABELA-EXTRATO)
           END-EXEC.

           STOP RUN.
