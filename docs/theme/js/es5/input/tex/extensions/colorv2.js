/* BEGIN MKDOCS TEMPLATE */
/* WARNING, DO NOT UPDATE CONTENT BETWEEN MKDOCS TEMPLATE TAG !*/
/* Modified content will be overwritten when updating.*/
!function(t){var e={};function o(a){if(e[a])return e[a].exports;var n=e[a]={i:a,l:!1,exports:{}};return t[a].call(n.exports,n,n.exports,o),n.l=!0,n.exports}o.m=t,o.c=e,o.d=function(t,e,a){o.o(t,e)||Object.defineProperty(t,e,{enumerable:!0,get:a})},o.r=function(t){"undefined"!=typeof Symbol&&Symbol.toStringTag&&Object.defineProperty(t,Symbol.toStringTag,{value:"Module"}),Object.defineProperty(t,"__esModule",{value:!0})},o.t=function(t,e){if(1&e&&(t=o(t)),8&e)return t;if(4&e&&"object"==typeof t&&t&&t.__esModule)return t;var a=Object.create(null);if(o.r(a),Object.defineProperty(a,"default",{enumerable:!0,value:t}),2&e&&"string"!=typeof t)for(var n in t)o.d(a,n,function(e){return t[e]}.bind(null,n));return a},o.n=function(t){var e=t&&t.__esModule?function(){return t.default}:function(){return t};return o.d(e,"a",e),e},o.o=function(t,e){return Object.prototype.hasOwnProperty.call(t,e)},o.p="",o(o.s=4)}([function(t,e,o){"use strict";Object.defineProperty(e,"__esModule",{value:!0}),e.isObject=MathJax._.components.global.isObject,e.combineConfig=MathJax._.components.global.combineConfig,e.combineDefaults=MathJax._.components.global.combineDefaults,e.combineWithMathJax=MathJax._.components.global.combineWithMathJax,e.MathJax=MathJax._.components.global.MathJax},function(t,e,o){"use strict";Object.defineProperty(e,"__esModule",{value:!0}),e.ColorConfiguration=e.ColorV2Methods=void 0;var a=o(2),n=o(3);e.ColorV2Methods={Color:function(t,e){var o=t.GetArgument(e),a=t.stack.env.color;t.stack.env.color=o;var n=t.ParseArg(e);a?t.stack.env.color=a:delete t.stack.env.color;var r=t.create("node","mstyle",[n],{mathcolor:o});t.Push(r)}},new a.CommandMap("colorv2",{color:"Color"},e.ColorV2Methods),e.ColorConfiguration=n.Configuration.create("colorv2",{handler:{macro:["colorv2"]}})},function(t,e,o){"use strict";Object.defineProperty(e,"__esModule",{value:!0}),e.AbstractSymbolMap=MathJax._.input.tex.SymbolMap.AbstractSymbolMap,e.RegExpMap=MathJax._.input.tex.SymbolMap.RegExpMap,e.AbstractParseMap=MathJax._.input.tex.SymbolMap.AbstractParseMap,e.CharacterMap=MathJax._.input.tex.SymbolMap.CharacterMap,e.DelimiterMap=MathJax._.input.tex.SymbolMap.DelimiterMap,e.MacroMap=MathJax._.input.tex.SymbolMap.MacroMap,e.CommandMap=MathJax._.input.tex.SymbolMap.CommandMap,e.EnvironmentMap=MathJax._.input.tex.SymbolMap.EnvironmentMap},function(t,e,o){"use strict";Object.defineProperty(e,"__esModule",{value:!0}),e.Configuration=MathJax._.input.tex.Configuration.Configuration,e.ConfigurationHandler=MathJax._.input.tex.Configuration.ConfigurationHandler,e.ParserConfiguration=MathJax._.input.tex.Configuration.ParserConfiguration},function(t,e,o){"use strict";o.r(e);var a=o(0),n=o(1);Object(a.combineWithMathJax)({_:{input:{tex:{colorv2:{ColorV2Configuration:n}}}}}),function(t,e,o){var n,r,i,c=MathJax.config.tex;if(c&&c.packages){var l=c.packages,u=l.indexOf(t);u>=0&&(l[u]=e),o&&c[t]&&(Object(a.combineConfig)(c,(n={},r=e,i=c[t],r in n?Object.defineProperty(n,r,{value:i,enumerable:!0,configurable:!0,writable:!0}):n[r]=i,n)),delete c[t])}}("colorV2","colorv2",!1)}]);
/* END MKDOCS TEMPLATE */