/* description: Parses end executes mathematical expressions. */

/* lexical grammar */
%lex
%%

\s+                   /* skip whitespace */
";"                   return yytext
[0-9]+("."[0-9]+)?\b  return 'NUMBER'
\b[A-Za-z_]\w*\b      return idORrw(yytext)
"="                   return '='
"*"                   return '*'
"/"                   return '/'
"-"                   return '-'
"+"                   return '+'
"^"                   return '^'
"!"                   return '!'
"%"                   return '%'
"("                   return '('
")"                   return ')'
"PI"                  return 'PI'
"E"                   return 'E'
<<EOF>>               return 'EOF'
.                     return 'INVALID'

%%

var reserved_words={PI : 'PI', E : 'E'};
function idORrw(x) {
   return ((x.toUpperCase() in reserved_words)? x.toUpperCase() : 'ID');
}

/lex

/* operator associations and precedence */

%right '='
%left '+' '-'
%left '*' '/'
%left '^'
%right '!'
%right '%'
%left UMINUS

%start expressions

%% /* language grammar */

expressions
    : e EOF
        {  
         typeof console !== 'undefined' ? console.log($1) : print($1);
         return $1 + ":" + identificadores[$1]; }
    | e ';' expressions
    | ';' expressions
    | ';' EOF
    | e ';' EOF
    ;

e
    : e '+' e
        {$$ = $1+$3;}
    | e '-' e
        {$$ = $1-$3;}
    | e '*' e
        {$$ = $1*$3;}
    | e '/' e
        {
           if ($3 == 0) {
              throw new Error ('Error no se puede dividir por 0')
           }
           else {
            $$ = $1/$3;
           }
        }
    | e '^' e
        {$$ = Math.pow($1, $3);}
    | e '!'
        {{
          $$ = (function fact (n) { return n==0 ? 1 : fact(n-1) * n })($1);
        }}
    | e '%'
        {$$ = $1/100;}
    | '-' e %prec UMINUS
        {$$ = -$2;}
    | '(' e ')'
        {$$ = $2;}
    | NUMBER
        {$$ = Number(yytext);}
    | E
        {$$ = Math.E;}
    | E '=' e { throw new Error (' Imposible modificar E '); }
    | PI
        {$$ = Math.PI;}
    | PI '=' e { throw new Error (' Imposible modificar PI '); }
    | ID '=' e {identificadores[$1]=$3;}
    | ID {
         if (identificadores[$1] != null)
            $$ = identificadores[$1];
         else
            throw new Error ('No existe el identificador ' + $1);
    }
    ;
%%
var identificadores={};
