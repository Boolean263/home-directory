      *Comment
       IDENTIFICATION DIVISION.
       PROGRAM-ID. ${1:`!v expand ("%:t")`}.
       AUTHOR. DAVID PERRY.
       DATE-WRITTEN. ${2:`!v strftime("%Y-%m-%d")`}.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT FILEHANDLE
               ASSIGN TO "FILENAME.DAT"
                   ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
           FD FILEHANDLE.
      *    describe fixed format here

       WORKING-STORAGE SECTION.
      * Declare variables here that you'll be using

       PROCEDURE DIVISION.
           ${0:DISPLAY "Hello, world".}
       END PROGRAM ${1:`!v expand ("%:t")`}.
