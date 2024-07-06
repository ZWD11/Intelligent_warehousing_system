exports.get=function(t,e,r){return void 0===(t=(e.split?e.split("."):e).reduce(function(t,e){return t&&t[e]},t))?r:t},exports.set=function(t,e,r,o){return!/^(__proto__|constructor|prototype)$/.test(e)&&((e=e.split?e.split("."):e.slice(0)).slice(0,-1).reduce(function(t,e){return t[e]=t[e]||{}},t)[e.pop()]=r),t};
//# sourceMappingURL=shvl.js.map
