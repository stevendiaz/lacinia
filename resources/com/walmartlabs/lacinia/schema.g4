grammar GraphqlSchema;

graphqlSchema
  : '{' (schemaDef|typeDef|inputTypeDef|unionDef|enumDef|interfaceDef|scalarDef)* '}'
  ;

description
  : StringValue
  | BlockStringValue
  ;

schemaDef
  : 'schema' '{' operationTypeDef+ '}'
  ;

operationTypeDef
  : queryOperationDef
  | mutationOperationDef
  | subscriptionOperationDef
  ;

queryOperationDef
  : 'query' ':' typeName
  ;

mutationOperationDef
  : 'mutation' ':' typeName
  ;

subscriptionOperationDef
  : 'subscription' ':' typeName
  ;

typeDef
  : description? 'type' typeName implementationDef? fieldDefs
  ;

fieldDefs
  : '{' fieldDef+ '}'
  ;


implementationDef
  : 'implements' typeName+
  ;

inputTypeDef
  : description? 'input' typeName fieldDefs
  ;

interfaceDef
  : description? 'interface' typeName fieldDefs
  ;

scalarDef
  : description? 'scalar' typeName
  ;

unionDef
  : description? 'union' typeName '=' unionTypes
  ;

unionTypes
  : (typeName '|')* typeName
  ;

enumDef
  : description? 'enum' typeName enumValueDefs
  ;

enumValueDefs
  : '{' enumValueDef+ '}'
  ;

enumValueDef
  : description? scalarName
  ;

scalarName
  : Name
  ;

fieldDef
  : description? fieldName fieldArgs? ':' typeSpec
  ;

fieldArgs
  : '(' argument+ ')'
  ;

fieldName
  : Name
  ;

argument
  : description? Name ':' typeSpec defaultValue?
  ;

typeSpec
  : (typeName|listType) required?
  ;

listType
  : '[' typeSpec ']'
  ;

required
  : '!'
  ;

typeName
  : Name
  ;

defaultValue
  : '=' value
  ;

BooleanValue
    : 'true'
    | 'false'
    ;

Name
  : [_A-Za-z][_0-9A-Za-z]*
  ;

value
    : IntValue
    | FloatValue
    | StringValue
    | BlockStringValue
    | BooleanValue
    | NullValue
    | enumValue
    | arrayValue
    | objectValue
    ;

enumValue
    : Name
    ;

arrayValue
    : '[' value* ']'
    ;

objectValue
    : '{' objectField* '}'
    ;

objectField
    : Name ':' value
    ;

NullValue
    : Null
    ;

Null
    : 'null'
    ;

IntValue
    : Sign? IntegerPart
    ;

FloatValue
    : Sign? IntegerPart ('.' Digit+)? ExponentPart?
    ;

Sign
    : '-'
    ;

IntegerPart
    : '0'
    | NonZeroDigit
    | NonZeroDigit Digit+
    ;

NonZeroDigit
    : '1'.. '9'
    ;

ExponentPart
    : ('e'|'E') Sign? Digit+
    ;

Digit
    : '0'..'9'
    ;

StringValue
    : DoubleQuote (~(["\\\n\r\u2028\u2029])|EscapedChar)* DoubleQuote
    ;

BlockStringValue
    : TripleQuote (.)*? TripleQuote
    ;

fragment EscapedChar
    :  '\\' (["\\/bfnrt] | Unicode)
    ;

fragment Unicode
   : 'u' Hex Hex Hex Hex
   ;

fragment DoubleQuote
   : '"'
   ;

fragment TripleQuote
  : '"""'
  ;

fragment Hex
   : [0-9a-fA-F]
   ;

Ignored
   : (Whitespace|Comma|LineTerminator|Comment) -> skip
   ;

fragment Comment
   : '#' ~[\n\r\u2028\u2029]*
   ;

fragment LineTerminator
   : [\n\r\u2028\u2029]
   ;

fragment Whitespace
   : [\t\u000b\f\u0020\u00a0]
   ;

fragment Comma
   : ','
   ;
