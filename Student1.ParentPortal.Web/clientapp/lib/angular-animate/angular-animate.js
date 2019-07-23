/*
 AngularJS v1.7.4
 (c) 2010-2018 Google, Inc. http://angularjs.org
 License: MIT
*/
(function(Y, z) {
'use strict';
function Fa(a, b, c) {
  if (!a) throw Pa('areq', b || '?', c || 'required');
  return a
}
function Ga(a, b) {
  if (!a && !b) return '';
  if (!a) return b;
  if (!b) return a;
  Z(a) && (a = a.join(' '));
  Z(b) && (b = b.join(' '));
  return a + ' ' + b
}
function Qa(a) {
  var b = {};
  a && (a.to || a.from) && (b.to = a.to, b.from = a.from);
  return b
}
function $(a, b, c) {
  var d = '';
  a = Z(a) ? a : a && G(a) && a.length ? a.split(/\s+/) : [];
  s(a, function(a, k) {
    a && 0 < a.length && (d += 0 < k ? ' ' : '', d += c ? b + a : a + b)
  });
  return d
}
function Ha(a) {
  if (a instanceof A) switch (a.length) {
      case 0:
        return a;
      case 1:
        if (1 === a[0].nodeType) return a;
        break;
      default:
        return A(va(a))
    }
  if (1 === a.nodeType) return A(a)
}
function va(a) {
  if (!a[0]) return a;
  for (var b = 0; b < a.length; b++) {
    var c = a[b];
    if (1 === c.nodeType) return c
  }
}
function Ra(a, b, c) {
  s(b, function(b) {
    a.addClass(b, c)
  })
}
function Sa(a, b, c) {
  s(b, function(b) {
    a.removeClass(b, c)
  })
}
function aa(a) {
  return function(b, c) {
    c.addClass && (Ra(a, b, c.addClass), c.addClass = null);
    c.removeClass && (Sa(a, b, c.removeClass), c.removeClass = null)
  }
}
function pa(a) {
  a = a || {};
  if (!a.$$prepared) {
    var b = a.domOperation || N;
    a.domOperation = function() {
      a.$$domOperationFired = !0;
      b();
      b = N
    };
    a.$$prepared = !0
  }
  return a
}
function ha(a, b) {
  Ia(a, b);
  Ja(a, b)
}
function Ia(a, b) {
  b.from && (a.css(b.from), b.from = null)
}
function Ja(a, b) {
  b.to && (a.css(b.to), b.to = null)
}
function T(a, b, c) {
  var d = b.options || {};
  c = c.options || {};
  var f = (d.addClass || '') + ' ' + (c.addClass || ''),
      k = (d.removeClass || '') + ' ' + (c.removeClass || '');
  a = Ta(a.attr('class'), f, k);
  c.preparationClasses &&
      (d.preparationClasses = ba(c.preparationClasses, d.preparationClasses),
       delete c.preparationClasses);
  f = d.domOperation !== N ? d.domOperation : null;
  wa(d, c);
  f && (d.domOperation = f);
  d.addClass = a.addClass ? a.addClass : null;
  d.removeClass = a.removeClass ? a.removeClass : null;
  b.addClass = d.addClass;
  b.removeClass = d.removeClass;
  return d
}
function Ta(a, b, c) {
  function d(a) {
    G(a) && (a = a.split(' '));
    var c = {};
    s(a, function(a) {
      a.length && (c[a] = !0)
    });
    return c
  }
  var f = {};
  a = d(a);
  b = d(b);
  s(b, function(a, c) {
    f[c] = 1
  });
  c = d(c);
  s(c, function(a, c) {
    f[c] = 1 === f[c] ? null : -1
  });
  var k = {addClass: '', removeClass: ''};
  s(f, function(c, b) {
    var d, f;
    1 === c ? (d = 'addClass', f = !a[b] || a[b + '-remove']) :
              -1 === c && (d = 'removeClass', f = a[b] || a[b + '-add']);
    f && (k[d].length && (k[d] += ' '), k[d] += b)
  });
  return k
}
function K(a) {
  return a instanceof A ? a[0] : a
}
function Ua(a, b, c, d) {
  a = '';
  c && (a = $(c, 'ng-', !0));
  d.addClass && (a = ba(a, $(d.addClass, '-add')));
  d.removeClass && (a = ba(a, $(d.removeClass, '-remove')));
  a.length && (d.preparationClasses = a, b.addClass(a))
}
function qa(a, b) {
  var c = b ? '-' + b + 's' : '';
  ma(a, [na, c]);
  return [na, c]
}
function xa(a, b) {
  var c = b ? 'paused' : '', d = ca + 'PlayState';
  ma(a, [d, c]);
  return [d, c]
}
function ma(a, b) {
  a.style[b[0]] = b[1]
}
function ba(a, b) {
  return a ? b ? a + ' ' + b : a : b
}
function Ka(a, b, c) {
  var d = Object.create(null), f = a.getComputedStyle(b) || {};
  s(c, function(a, c) {
    var b = f[a];
    if (b) {
      var L = b.charAt(0);
      if ('-' === L || '+' === L || 0 <= L) b = Va(b);
      0 === b && (b = null);
      d[c] = b
    }
  });
  return d
}
function Va(a) {
  var b = 0;
  a = a.split(/\s*,\s*/);
  s(a, function(a) {
    's' === a.charAt(a.length - 1) && (a = a.substring(0, a.length - 1));
    a = parseFloat(a) || 0;
    b = b ? Math.max(a, b) : a
  });
  return b
}
function ya(a) {
  return 0 === a || null != a
}
function La(a, b) {
  var c = M, d = a + 's';
  b ? c += 'Duration' : d += ' linear all';
  return [c, d]
}
function Ma(a, b, c) {
  s(c, function(c) {
    a[c] = za(a[c]) ? a[c] : b.style.getPropertyValue(c)
  })
}
var M, Aa, ca, Ba;
void 0 === Y.ontransitionend && void 0 !== Y.onwebkittransitionend ?
    (M = 'WebkitTransition', Aa = 'webkitTransitionEnd transitionend') :
    (M = 'transition', Aa = 'transitionend');
void 0 === Y.onanimationend && void 0 !== Y.onwebkitanimationend ?
    (ca = 'WebkitAnimation', Ba = 'webkitAnimationEnd animationend') :
    (ca = 'animation', Ba = 'animationend');
var ra = ca + 'Delay', Ca = ca + 'Duration', na = M + 'Delay',
    Na = M + 'Duration', Pa = z.$$minErr('ng'), Wa = {
      transitionDuration: Na,
      transitionDelay: na,
      transitionProperty: M + 'Property',
      animationDuration: Ca,
      animationDelay: ra,
      animationIterationCount: ca + 'IterationCount'
    },
    Xa = {
      transitionDuration: Na,
      transitionDelay: na,
      animationDuration: Ca,
      animationDelay: ra
    },
    Da, wa, s, Z, za, sa, Ea, ta, G, R, A, N;
z.module(
     'ngAnimate', [],
     function() {
       N = z.noop;
       Da = z.copy;
       wa = z.extend;
       A = z.element;
       s = z.forEach;
       Z = z.isArray;
       G = z.isString;
       ta = z.isObject;
       R = z.isUndefined;
       za = z.isDefined;
       Ea = z.isFunction;
       sa = z.isElement
     })
    .info({angularVersion: '1.7.4'})
    .directive(
        'ngAnimateSwap',
        [
          '$animate',
          function(a) {
            return {
              restrict: 'A', transclude: 'element', terminal: !0, priority: 600,
                  link: function(b, c, d, f, k) {
                    var e, Q;
                    b.$watchCollection(
                        d.ngAnimateSwap || d['for'], function(b) {
                          e && a.leave(e);
                          Q && (Q.$destroy(), Q = null);
                          (b || 0 === b) && k(function(b, d) {
                            e = b;
                            Q = d;
                            a.enter(b, null, c)
                          })
                        })
                  }
            }
          }
        ])
    .directive(
        'ngAnimateChildren',
        [
          '$interpolate',
          function(a) {
            return {
              link: function(b, c, d) {
                function f(a) {
                  c.data('$$ngAnimateChildren', 'on' === a || 'true' === a)
                }
                var k = d.ngAnimateChildren;
                G(k) && 0 === k.length ?
                    c.data('$$ngAnimateChildren', !0) :
                    (f(a(k)(b)), d.$observe('ngAnimateChildren', f))
              }
            }
          }
        ])
    .factory(
        '$$rAFScheduler',
        [
          '$$rAF',
          function(a) {
            function b(a) {
              d = d.concat(a);
              c()
            }
            function c() {
              if (d.length) {
                for (var b = d.shift(), e = 0; e < b.length; e++) b[e]();
                f || a(function() {
                  f || c()
                })
              }
            }
            var d, f;
            d = b.queue = [];
            b.waitUntilQuiet = function(b) {
              f && f();
              f = a(function() {
                f = null;
                b();
                c()
              })
            };
            return b
          }
        ])
    .provider(
        '$$animateQueue',
        [
          '$animateProvider',
          function(a) {
            function b(a) {
              return {
                addClass: a.addClass, removeClass: a.removeClass, from: a.from,
                    to: a.to
              }
            }
            function c(a) {
              if (!a) return null;
              a = a.split(' ');
              var b = Object.create(null);
              s(a, function(a) {
                b[a] = !0
              });
              return b
            }
            function d(a, b) {
              if (a && b) {
                var d = c(b);
                return a.split(' ').some(function(a) {
                  return d[a]
                })
              }
            }
            function f(a, b, c) {
              return e[a].some(function(a) {
                return a(b, c)
              })
            }
            function k(a, b) {
              var c = 0 < (a.addClass || '').length,
                  d = 0 < (a.removeClass || '').length;
              return b ? c && d : c || d
            }
            var e = this.rules = {skip: [], cancel: [], join: []};
            e.join.push(function(a, b) {
              return !a.structural && k(a)
            });
            e.skip.push(function(a, b) {
              return !a.structural && !k(a)
            });
            e.skip.push(function(a, b) {
              return 'leave' === b.event && a.structural
            });
            e.skip.push(function(a, b) {
              return b.structural && 2 === b.state && !a.structural
            });
            e.cancel.push(function(a, b) {
              return b.structural && a.structural
            });
            e.cancel.push(function(a, b) {
              return 2 === b.state && a.structural
            });
            e.cancel.push(function(a, b) {
              if (b.structural) return !1;
              var c = a.addClass, f = a.removeClass, k = b.addClass,
                  e = b.removeClass;
              return R(c) && R(f) || R(k) && R(e) ? !1 : d(c, e) || d(f, k)
            });
            this.$get = [
              '$$rAF', '$rootScope', '$rootElement', '$document', '$$Map',
              '$$animation', '$$AnimateRunner', '$templateRequest', '$$jqLite',
              '$$forceReflow', '$$isDocumentHidden',
              function(c, d, e, C, U, oa, H, u, t, I, da) {
                function ia(a) {
                  O.delete(a.target)
                }
                function v() {
                  var a = !1;
                  return function(b) {
                    a ? b() : d.$$postDigest(function() {
                      a = !0;
                      b()
                    })
                  }
                }
                function ua(a, b, c) {
                  var g = [], l = m[c];
                  l && s(l, function(l) {
                    Oa.call(l.node, b) ? g.push(l.callback) :
                                         'leave' === c && Oa.call(l.node, a) &&
                            g.push(l.callback)
                  });
                  return g
                }
                function h(a, b, c) {
                  var l = va(b);
                  return a.filter(function(a) {
                    return !(a.node === l && (!c || a.callback === c))
                  })
                }
                function q(a, J, w) {
                  function e(a, b, l, g) {
                    u(function() {
                      var a = ua(ia, m, b);
                      a.length ? c(function() {
                        s(a, function(a) {
                          a(h, l, g)
                        });
                        'close' !== l || m.parentNode || D.off(m)
                      }) :
                                 'close' !== l || m.parentNode || D.off(m)
                    });
                    a.progress(b, l, g)
                  }
                  function I(a) {
                    var b = h, c = n;
                    c.preparationClasses &&
                        (b.removeClass(c.preparationClasses),
                         c.preparationClasses = null);
                    c.activeClasses &&
                        (b.removeClass(c.activeClasses),
                         c.activeClasses = null);
                    W(h, n);
                    ha(h, n);
                    n.domOperation();
                    q.complete(!a)
                  }
                  var n = Da(w), h = Ha(a), m = K(h), ia = m && m.parentNode,
                      n = pa(n), q = new H, u = v();
                  Z(n.addClass) && (n.addClass = n.addClass.join(' '));
                  n.addClass && !G(n.addClass) && (n.addClass = null);
                  Z(n.removeClass) && (n.removeClass = n.removeClass.join(' '));
                  n.removeClass && !G(n.removeClass) && (n.removeClass = null);
                  n.from && !ta(n.from) && (n.from = null);
                  n.to && !ta(n.to) && (n.to = null);
                  if (!(B && m && fa(m, J, w) && Ya(m, n))) return I(), q;
                  var x = 0 <= ['enter', 'move', 'leave'].indexOf(J), r = da(),
                      P = r || O.get(m);
                  w = !P && y.get(m) || {};
                  var p = !!w.state;
                  P || p && 1 === w.state || (P = !E(m, ia, J));
                  if (P)
                    return r && e(q, J, 'start', b(n)), I(),
                           r && e(q, J, 'close', b(n)), q;
                  x && F(m);
                  r = {
                    structural: x,
                    element: h,
                    event: J,
                    addClass: n.addClass,
                    removeClass: n.removeClass,
                    close: I,
                    options: n,
                    runner: q
                  };
                  if (p) {
                    if (f('skip', r, w)) {
                      if (2 === w.state) return I(), q;
                      T(h, w, r);
                      return w.runner
                    }
                    if (f('cancel', r, w))
                      if (2 === w.state)
                        w.runner.end();
                      else if (w.structural)
                        w.close();
                      else
                        return T(h, w, r), w.runner;
                    else if (f('join', r, w))
                      if (2 === w.state)
                        T(h, r, {});
                      else
                        return Ua(t, h, x ? J : null, n),
                               J = r.event = w.event, n = T(h, w, r), w.runner
                  } else
                    T(h, r, {});
                  (p = r.structural) ||
                      (p = 'animate' === r.event &&
                               0 < Object.keys(r.options.to || {}).length ||
                           k(r));
                  if (!p) return I(), g(m), q;
                  var C = (w.counter || 0) + 1;
                  r.counter = C;
                  l(m, 1, r);
                  d.$$postDigest(function() {
                    h = Ha(a);
                    var c = y.get(m), d = !c, c = c || {},
                        t = 0 < (h.parent() || []).length &&
                        ('animate' === c.event || c.structural || k(c));
                    if (d || c.counter !== C || !t) {
                      d && (W(h, n), ha(h, n));
                      if (d || x && c.event !== J) n.domOperation(), q.end();
                      t || g(m)
                    } else
                      J = !c.structural && k(c, !0) ? 'setClass' : c.event,
                      l(m, 2), c = oa(h, J, c.options), q.setHost(c),
                      e(q, J, 'start', b(n)), c.done(function(a) {
                        I(!a);
                        (a = y.get(m)) && a.counter === C && g(m);
                        e(q, J, 'close', b(n))
                      })
                  });
                  return q
                }
                function F(a) {
                  a = a.querySelectorAll('[data-ng-animate]');
                  s(a, function(a) {
                    var b = parseInt(a.getAttribute('data-ng-animate'), 10),
                        c = y.get(a);
                    if (c) switch (b) {
                        case 2:
                          c.runner.end();
                        case 1:
                          y.delete(a)
                      }
                  })
                }
                function g(a) {
                  a.removeAttribute('data-ng-animate');
                  y.delete(a)
                }
                function E(a, b, c) {
                  c = C[0].body;
                  var l = K(e), g = a === c || 'HTML' === a.nodeName,
                      d = a === l, t = !1, m = O.get(a), h;
                  for ((a = A.data(a, '$ngAnimatePin')) && (b = K(a)); b;) {
                    d || (d = b === l);
                    if (1 !== b.nodeType) break;
                    a = y.get(b) || {};
                    if (!t) {
                      var f = O.get(b);
                      if (!0 === f && !1 !== m) {
                        m = !0;
                        break
                      } else
                        !1 === f && (m = !1);
                      t = a.structural
                    }
                    if (R(h) || !0 === h)
                      a = A.data(b, '$$ngAnimateChildren'), za(a) && (h = a);
                    if (t && !1 === h) break;
                    g || (g = b === c);
                    if (g && d) break;
                    if (!d && (a = A.data(b, '$ngAnimatePin'))) {
                      b = K(a);
                      continue
                    }
                    b = b.parentNode
                  }
                  return (!t || h) && !0 !== m && d && g
                }
                function l(a, b, c) {
                  c = c || {};
                  c.state = b;
                  a.setAttribute('data-ng-animate', b);
                  c = (b = y.get(a)) ? wa(b, c) : c;
                  y.set(a, c)
                }
                var y = new U, O = new U, B = null,
                    P = d.$watch(
                        function() {
                          return 0 === u.totalPendingRequests
                        },
                        function(a) {
                          a && (P(), d.$$postDigest(function() {
                            d.$$postDigest(function() {
                              null === B && (B = !0)
                            })
                          }))
                        }),
                    m = Object.create(null);
                U = a.customFilter();
                var la = a.classNameFilter();
                I = function() {
                  return !0
                };
                var fa = U || I,
                    Ya = la ?
                    function(a, b) {
                      var c = [
                        a.getAttribute('class'), b.addClass, b.removeClass
                      ].join(' ');
                      return la.test(c)
                    } :
                    I,
                    W = aa(t), Oa = Y.Node.prototype.contains || function(a) {
                      return this === a ||
                          !!(this.compareDocumentPosition(a) & 16)
                    }, D = {
                      on: function(a, b, c) {
                        var l = va(b);
                        m[a] = m[a] || [];
                        m[a].push({node: l, callback: c});
                        A(b).on('$destroy', function() {
                          y.get(l) || D.off(a, b, c)
                        })
                      },
                      off: function(a, b, c) {
                        if (1 !== arguments.length || G(arguments[0])) {
                          var l = m[a];
                          l &&
                              (m[a] =
                                   1 === arguments.length ? null : h(l, b, c))
                        } else
                          for (l in b = arguments[0], m) m[l] = h(m[l], b)
                      },
                      pin: function(a, b) {
                        Fa(sa(a), 'element', 'not an element');
                        Fa(sa(b), 'parentElement', 'not an element');
                        a.data('$ngAnimatePin', b)
                      },
                      push: function(a, b, c, l) {
                        c = c || {};
                        c.domOperation = l;
                        return q(a, b, c)
                      },
                      enabled: function(a, b) {
                        var c = arguments.length;
                        if (0 === c)
                          b = !!B;
                        else if (sa(a)) {
                          var l = K(a);
                          if (1 === c)
                            b = !O.get(l);
                          else {
                            if (!O.has(l)) A(a).on('$destroy', ia);
                            O.set(l, !b)
                          }
                        } else
                          b = B = !!a;
                        return b
                      }
                    };
                return D
              }
            ]
          }
        ])
    .provider(
        '$$animateCache',
        function() {
          var a = 0, b = Object.create(null);
          this.$get = [function() {
            return {
              cacheKey: function(b, d, f, k) {
                var e = b.parentNode;
                b = [
                  e.$$ngAnimateParentKey || (e.$$ngAnimateParentKey = ++a), d,
                  b.getAttribute('class')
                ];
                f && b.push(f);
                k && b.push(k);
                return b.join(' ')
              }, containsCachedAnimationWithoutDuration: function(a) {
                return (a = b[a]) && !a.isValid || !1
              }, flush: function() {
                b = Object.create(null)
              }, count: function(a) {
                return (a = b[a]) ? a.total : 0
              }, get: function(a) {
                return (a = b[a]) && a.value
              }, put: function(a, d, f) {
                b[a] ? (b[a].total++, b[a].value = d) : b[a] = {
                  total: 1,
                  value: d,
                  isValid: f
                }
              }
            }
          }]
        })
    .provider(
        '$$animation',
        [
          '$animateProvider',
          function(a) {
            var b = this.drivers = [];
            this.$get = [
              '$$jqLite', '$rootScope', '$injector', '$$AnimateRunner', '$$Map',
              '$$rAFScheduler', '$$animateCache',
              function(a, d, f, k, e, Q, L) {
                function x(a) {
                  function b(a) {
                    if (a.processed) return a;
                    a.processed = !0;
                    var d = a.domNode, t = d.parentNode;
                    f.set(d, a);
                    for (var h; t;) {
                      if (h = f.get(t)) {
                        h.processed || (h = b(h));
                        break
                      }
                      t = t.parentNode
                    }
                    (h || c).children.push(a);
                    return a
                  }
                  var c = {children: []}, d, f = new e;
                  for (d = 0; d < a.length; d++) {
                    var da = a[d];
                    f.set(da.domNode, a[d] = {
                      domNode: da.domNode,
                      element: da.element,
                      fn: da.fn,
                      children: []
                    })
                  }
                  for (d = 0; d < a.length; d++) b(a[d]);
                  return function(a) {
                    var b = [], c = [], d;
                    for (d = 0; d < a.children.length; d++)
                      c.push(a.children[d]);
                    a = c.length;
                    var t = 0, f = [];
                    for (d = 0; d < c.length; d++) {
                      var g = c[d];
                      0 >= a && (a = t, t = 0, b.push(f), f = []);
                      f.push(g);
                      g.children.forEach(function(a) {
                        t++;
                        c.push(a)
                      });
                      a--
                    }
                    f.length && b.push(f);
                    return b
                  }(c)
                }
                var C = [], U = aa(a);
                return function(e, H, u) {
                  function t(a) {
                    a = a.hasAttribute('ng-animate-ref') ?
                        [a] :
                        a.querySelectorAll('[ng-animate-ref]');
                    var b = [];
                    s(a, function(a) {
                      var c = a.getAttribute('ng-animate-ref');
                      c && c.length && b.push(a)
                    });
                    return b
                  }
                  function I(a) {
                    var b = [], c = {};
                    s(a, function(a, d) {
                      var l = K(a.element),
                          g = 0 <= ['enter', 'move'].indexOf(a.event),
                          l = a.structural ? t(l) : [];
                      if (l.length) {
                        var f = g ? 'to' : 'from';
                        s(l, function(a) {
                          var b = a.getAttribute('ng-animate-ref');
                          c[b] = c[b] || {};
                          c[b][f] = { animationID: d, element: A(a) }
                        })
                      } else
                        b.push(a)
                    });
                    var d = {}, g = {};
                    s(c, function(c, t) {
                      var f = c.from, e = c.to;
                      if (f && e) {
                        var h = a[f.animationID], k = a[e.animationID],
                            E = f.animationID.toString();
                        if (!g[E]) {
                          var I = g[E] = {
                            structural: !0,
                            beforeStart: function() {
                              h.beforeStart();
                              k.beforeStart()
                            },
                            close: function() {
                              h.close();
                              k.close()
                            },
                            classes: da(h.classes, k.classes),
                            from: h,
                            to: k,
                            anchors: []
                          };
                          I.classes.length ? b.push(I) : (b.push(h), b.push(k))
                        }
                        g[E].anchors.push({out: f.element, 'in': e.element})
                      } else
                        f = f ? f.animationID : e.animationID, e = f.toString(),
                        d[e] || (d[e] = !0, b.push(a[f]))
                    });
                    return b
                  }
                  function da(a, b) {
                    a = a.split(' ');
                    b = b.split(' ');
                    for (var c = [], d = 0; d < a.length; d++) {
                      var g = a[d];
                      if ('ng-' !== g.substring(0, 3))
                        for (var t = 0; t < b.length; t++)
                          if (g === b[t]) {
                            c.push(g);
                            break
                          }
                    }
                    return c.join(' ')
                  }
                  function ia(a) {
                    for (var c = b.length - 1; 0 <= c; c--) {
                      var d = f.get(b[c])(a);
                      if (d) return d
                    }
                  }
                  function v(a, b) {
                    function c(a) {
                      (a = a.data('$$animationRunner')) && a.setHost(b)
                    }
                    a.from && a.to ? (c(a.from.element), c(a.to.element)) :
                                     c(a.element)
                  }
                  function ua() {
                    var a = e.data('$$animationRunner');
                    !a || 'leave' === H && u.$$domOperationFired || a.end()
                  }
                  function h(b) {
                    e.off('$destroy', ua);
                    e.removeData('$$animationRunner');
                    U(e, u);
                    ha(e, u);
                    u.domOperation();
                    E && a.removeClass(e, E);
                    F.complete(!b)
                  }
                  u = pa(u);
                  var q = 0 <= ['enter', 'move', 'leave'].indexOf(H),
                      F = new k({
                        end: function() {
                          h()
                        },
                        cancel: function() {
                          h(!0)
                        }
                      });
                  if (!b.length) return h(), F;
                  var g = Ga(e.attr('class'), Ga(u.addClass, u.removeClass)),
                      E = u.tempClasses;
                  E && (g += ' ' + E, u.tempClasses = null);
                  q &&
                      e.data('$$animatePrepareClasses', 'ng-' + H + '-prepare');
                  e.data('$$animationRunner', F);
                  C.push({
                    element: e,
                    classes: g,
                    event: H,
                    structural: q,
                    options: u,
                    beforeStart: function() {
                      E = (E ? E + ' ' : '') + 'ng-animate';
                      a.addClass(e, E);
                      var b = e.data('$$animatePrepareClasses');
                      b && a.removeClass(e, b)
                    },
                    close: h
                  });
                  e.on('$destroy', ua);
                  if (1 < C.length) return F;
                  d.$$postDigest(function() {
                    var b = [];
                    s(C, function(a) {
                      a.element.data('$$animationRunner') ? b.push(a) :
                                                            a.close()
                    });
                    C.length = 0;
                    var d = I(b), g = [];
                    s(d, function(a) {
                      var b = a.from ? a.from.element : a.element,
                          c = u.addClass,
                          d = L.cacheKey(
                              b[0], a.event, (c ? c + ' ' : '') + 'ng-animate',
                              u.removeClass);
                      g.push({
                        element: b,
                        domNode: K(b),
                        fn: function() {
                          var b, c = a.close;
                          if (L.containsCachedAnimationWithoutDuration(d))
                            c();
                          else {
                            a.beforeStart();
                            if ((a.anchors ? a.from.element || a.to.element :
                                             a.element)
                                    .data('$$animationRunner')) {
                              var g = ia(a);
                              g && (b = g.start)
                            }
                            b ? (b = b(), b.done(function(a) {
                              c(!a)
                            }),
                                 v(a, b)) :
                                c()
                          }
                        }
                      })
                    });
                    for (var d = x(g), t = 0; t < d.length; t++)
                      for (var f = d[t], e = 0; e < f.length; e++) {
                        var h = f[e], k = h.element;
                        d[t][e] = h.fn;
                        0 === t ? k.removeData('$$animatePrepareClasses') :
                                  (h = k.data('$$animatePrepareClasses')) &&
                                a.addClass(k, h)
                      }
                    Q(d)
                  });
                  return F
                }
              }
            ]
          }
        ])
    .provider(
        '$animateCss',
        [
          '$animateProvider',
          function(a) {
            this.$get = [
              '$window', '$$jqLite', '$$AnimateRunner', '$timeout',
              '$$animateCache', '$$forceReflow', '$sniffer', '$$rAFScheduler',
              '$$animateQueue',
              function(a, c, d, f, k, e, Q, L, x) {
                function C(d, f, e, x) {
                  var v, s = 'stagger-' + e;
                  0 < k.count(e) &&
                      (v = k.get(s),
                       v ||
                           (f = $(f, '-stagger'), c.addClass(d, f),
                            v = Ka(a, d, x),
                            v.animationDuration =
                                Math.max(v.animationDuration, 0),
                            v.transitionDuration =
                                Math.max(v.transitionDuration, 0),
                            c.removeClass(d, f), k.put(s, v, !0)));
                  return v || {}
                }
                function U(a) {
                  u.push(a);
                  L.waitUntilQuiet(function() {
                    k.flush();
                    for (var a = e(), b = 0; b < u.length; b++) u[b](a);
                    u.length = 0
                  })
                }
                function z(c, d, f, e) {
                  d = k.get(f);
                  d ||
                      (d = Ka(a, c, Wa),
                       'infinite' === d.animationIterationCount &&
                           (d.animationIterationCount = 1));
                  k.put(
                      f, d,
                      e || 0 < d.transitionDuration || 0 < d.animationDuration);
                  c = d;
                  f = c.animationDelay;
                  e = c.transitionDelay;
                  c.maxDelay = f && e ? Math.max(f, e) : f || e;
                  c.maxDuration = Math.max(
                      c.animationDuration * c.animationIterationCount,
                      c.transitionDuration);
                  return c
                }
                var H = aa(c), u = [];
                return function(a, b) {
                  function e() {
                    v()
                  }
                  function L() {
                    v(!0)
                  }
                  function v(b) {
                    if (!(P || la && m)) {
                      P = !0;
                      m = !1;
                      V && !g.$$skipPreparationClasses && c.removeClass(a, V);
                      ba && c.removeClass(a, ba);
                      xa(l, !1);
                      qa(l, !1);
                      s(y, function(a) {
                        l.style[a[0]] = ''
                      });
                      H(a, g);
                      ha(a, g);
                      Object.keys(E).length && s(E, function(a, b) {
                        a ? l.style.setProperty(b, a) :
                            l.style.removeProperty(b)
                      });
                      if (g.onDone) g.onDone();
                      w && w.length && a.off(w.join(' '), q);
                      var d = a.data('$$animateCss');
                      d && (f.cancel(d[0].timer), a.removeData('$$animateCss'));
                      fa && fa.complete(!b)
                    }
                  }
                  function u(a) {
                    p.blockTransition && qa(l, a);
                    p.blockKeyframeAnimation && xa(l, !!a)
                  }
                  function h() {
                    fa = new d({end: e, cancel: L});
                    U(N);
                    v();
                    return {
                      $$willAnimate: !1, start: function() {
                        return fa
                      }, end: e
                    }
                  }
                  function q(a) {
                    a.stopPropagation();
                    var b = a.originalEvent || a;
                    b.target === l &&
                        (a = b.$manualTimeStamp || Date.now(),
                         b = parseFloat(b.elapsedTime.toFixed(3)),
                         Math.max(a - J, 0) >= G && b >= D && (la = !0, v()))
                  }
                  function F() {
                    function b() {
                      if (!P) {
                        u(!1);
                        s(y, function(a) {
                          l.style[a[0]] = a[1]
                        });
                        H(a, g);
                        c.addClass(a, ba);
                        if (p.recalculateTimingStyles) {
                          T = l.getAttribute('class') + ' ' + V;
                          ka = k.cacheKey(l, ja, g.addClass, g.removeClass);
                          r = z(l, T, ka, !1);
                          ga = r.maxDelay;
                          W = Math.max(ga, 0);
                          D = r.maxDuration;
                          if (0 === D) {
                            v();
                            return
                          }
                          p.hasTransitions = 0 < r.transitionDuration;
                          p.hasAnimations = 0 < r.animationDuration
                        }
                        p.applyAnimationDelay &&
                            (ga = 'boolean' !== typeof g.delay && ya(g.delay) ?
                                 parseFloat(g.delay) :
                                 ga,
                             W = Math.max(ga, 0), r.animationDelay = ga,
                             ea = [ra, ga + 's'], y.push(ea),
                             l.style[ea[0]] = ea[1]);
                        G = 1E3 * W;
                        R = 1E3 * D;
                        if (g.easing) {
                          var e, h = g.easing;
                          p.hasTransitions &&
                              (e = M + 'TimingFunction', y.push([e, h]),
                               l.style[e] = h);
                          p.hasAnimations &&
                              (e = ca + 'TimingFunction', y.push([e, h]),
                               l.style[e] = h)
                        }
                        r.transitionDuration && w.push(Aa);
                        r.animationDuration && w.push(Ba);
                        J = Date.now();
                        var m = G + 1.5 * R;
                        e = J + m;
                        var h = a.data('$$animateCss') || [], F = !0;
                        if (h.length) {
                          var n = h[0];
                          (F = e > n.expectedEndTime) ? f.cancel(n.timer) :
                                                        h.push(v)
                        }
                        F &&
                            (m = f(d, m, !1),
                             h[0] = {timer: m, expectedEndTime: e}, h.push(v),
                             a.data('$$animateCss', h));
                        if (w.length) a.on(w.join(' '), q);
                        g.to &&
                            (g.cleanupStyles && Ma(E, l, Object.keys(g.to)),
                             Ja(a, g))
                      }
                    }
                    function d() {
                      var b = a.data('$$animateCss');
                      if (b) {
                        for (var c = 1; c < b.length; c++) b[c]();
                        a.removeData('$$animateCss')
                      }
                    }
                    if (!P)
                      if (l.parentNode) {
                        var e =
                                function(a) {
                          if (la)
                            m && a && (m = !1, v());
                          else if (m = !a, r.animationDuration)
                            if (a = xa(l, m), m)
                              y.push(a);
                            else {
                              var b = y, c = b.indexOf(a);
                              0 <= a && b.splice(c, 1)
                            }
                        },
                            h = 0 < aa &&
                            (r.transitionDuration &&
                                 0 === X.transitionDuration ||
                             r.animationDuration &&
                                 0 === X.animationDuration) &&
                            Math.max(X.animationDelay, X.transitionDelay);
                        h ? f(b, Math.floor(h * aa * 1E3), !1) : b();
                        A.resume = function() {
                          e(!0)
                        };
                        A.pause = function() {
                          e(!1)
                        }
                      } else
                        v()
                  }
                  var g = b || {};
                  g.$$prepared || (g = pa(Da(g)));
                  var E = {}, l = K(a);
                  if (!l || !l.parentNode || !x.enabled()) return h();
                  var y = [], O = a.attr('class'), B = Qa(g), P, m, la, fa, A,
                      W, G, D, R, J, w = [];
                  if (0 === g.duration || !Q.animations && !Q.transitions)
                    return h();
                  var ja = g.event && Z(g.event) ? g.event.join(' ') : g.event,
                      Y = ja && g.structural, n = '', S = '';
                  Y ? n = $(ja, 'ng-', !0) : ja && (n = ja);
                  g.addClass && (S += $(g.addClass, '-add'));
                  g.removeClass &&
                      (S.length && (S += ' '),
                       S += $(g.removeClass, '-remove'));
                  g.applyClassesEarly && S.length && H(a, g);
                  var V = [n, S].join(' ').trim(), T = O + ' ' + V,
                      O = B.to && 0 < Object.keys(B.to).length;
                  if (!(0 < (g.keyframeStyle || '').length || O || V))
                    return h();
                  var X, ka = k.cacheKey(l, ja, g.addClass, g.removeClass);
                  if (k.containsCachedAnimationWithoutDuration(ka))
                    return V = null, h();
                  0 < g.stagger ? (B = parseFloat(g.stagger), X = {
                    transitionDelay: B,
                    animationDelay: B,
                    transitionDuration: 0,
                    animationDuration: 0
                  }) :
                                  X = C(l, V, ka, Xa);
                  g.$$skipPreparationClasses || c.addClass(a, V);
                  g.transitionStyle &&
                      (B = [M, g.transitionStyle], ma(l, B), y.push(B));
                  0 <= g.duration &&
                      (B = 0 < l.style[M].length, B = La(g.duration, B),
                       ma(l, B), y.push(B));
                  g.keyframeStyle &&
                      (B = [ca, g.keyframeStyle], ma(l, B), y.push(B));
                  var aa = X ?
                      0 <= g.staggerIndex ? g.staggerIndex : k.count(ka) :
                      0;
                  (n = 0 === aa) && !g.skipBlocking && qa(l, 9999);
                  var r = z(l, T, ka, !Y), ga = r.maxDelay;
                  W = Math.max(ga, 0);
                  D = r.maxDuration;
                  var p = {};
                  p.hasTransitions = 0 < r.transitionDuration;
                  p.hasAnimations = 0 < r.animationDuration;
                  p.hasTransitionAll =
                      p.hasTransitions && 'all' === r.transitionProperty;
                  p.applyTransitionDuration = O &&
                      (p.hasTransitions && !p.hasTransitionAll ||
                       p.hasAnimations && !p.hasTransitions);
                  p.applyAnimationDuration = g.duration && p.hasAnimations;
                  p.applyTransitionDelay = ya(g.delay) &&
                      (p.applyTransitionDuration || p.hasTransitions);
                  p.applyAnimationDelay = ya(g.delay) && p.hasAnimations;
                  p.recalculateTimingStyles = 0 < S.length;
                  if (p.applyTransitionDuration || p.applyAnimationDuration)
                    D = g.duration ? parseFloat(g.duration) : D,
                    p.applyTransitionDuration &&
                        (p.hasTransitions = !0, r.transitionDuration = D,
                         B = 0 < l.style[M + 'Property'].length,
                         y.push(La(D, B))),
                    p.applyAnimationDuration &&
                        (p.hasAnimations = !0, r.animationDuration = D,
                         y.push([Ca, D + 's']));
                  if (0 === D && !p.recalculateTimingStyles) return h();
                  var ba = $(V, '-active');
                  if (null != g.delay) {
                    var ea;
                    'boolean' !== typeof g.delay &&
                        (ea = parseFloat(g.delay), W = Math.max(ea, 0));
                    p.applyTransitionDelay && y.push([na, ea + 's']);
                    p.applyAnimationDelay && y.push([ra, ea + 's'])
                  }
                  null == g.duration && 0 < r.transitionDuration &&
                      (p.recalculateTimingStyles =
                           p.recalculateTimingStyles || n);
                  G = 1E3 * W;
                  R = 1E3 * D;
                  g.skipBlocking ||
                      (p.blockTransition = 0 < r.transitionDuration,
                       p.blockKeyframeAnimation = 0 < r.animationDuration &&
                           0 < X.animationDelay && 0 === X.animationDuration);
                  g.from &&
                      (g.cleanupStyles && Ma(E, l, Object.keys(g.from)),
                       Ia(a, g));
                  p.blockTransition || p.blockKeyframeAnimation ?
                      u(D) :
                      g.skipBlocking || qa(l, !1);
                  return {
                    $$willAnimate: !0, end: e, start: function() {
                      if (!P)
                        return A = {
                          end: e,
                          cancel: L,
                          resume: null,
                          pause: null
                        },
                               fa = new d(A), U(F), fa
                    }
                  }
                }
              }
            ]
          }
        ])
    .provider(
        '$$animateCssDriver',
        [
          '$$animationProvider',
          function(a) {
            a.drivers.push('$$animateCssDriver');
            this.$get = [
              '$animateCss', '$rootScope', '$$AnimateRunner', '$rootElement',
              '$sniffer', '$$jqLite', '$document',
              function(a, c, d, f, k, e, Q) {
                function L(a) {
                  return a.replace(/\bng-\S+\b/g, '')
                }
                function x(a, b) {
                  G(a) && (a = a.split(' '));
                  G(b) && (b = b.split(' '));
                  return a
                      .filter(function(a) {
                        return -1 === b.indexOf(a)
                      })
                      .join(' ')
                }
                function C(c, e, f) {
                  function k(a) {
                    var b = {}, c = K(a).getBoundingClientRect();
                    s(['width', 'height', 'top', 'left'], function(a) {
                      var d = c[a];
                      switch (a) {
                        case 'top':
                          d += H.scrollTop;
                          break;
                        case 'left':
                          d += H.scrollLeft
                      }
                      b[a] = Math.floor(d) + 'px'
                    });
                    return b
                  }
                  function v() {
                    var c = L(f.attr('class') || ''), d = x(c, q), c = x(q, c),
                        d = a(h, {
                          to: k(f),
                          addClass: 'ng-anchor-in ' + d,
                          removeClass: 'ng-anchor-out ' + c,
                          delay: !0
                        });
                    return d.$$willAnimate ? d : null
                  }
                  function C() {
                    h.remove();
                    e.removeClass('ng-animate-shim');
                    f.removeClass('ng-animate-shim')
                  }
                  var h = A(K(e).cloneNode(!0)), q = L(h.attr('class') || '');
                  e.addClass('ng-animate-shim');
                  f.addClass('ng-animate-shim');
                  h.addClass('ng-anchor');
                  u.append(h);
                  var F;
                  c = function() {
                    var c = a(
                        h, {addClass: 'ng-anchor-out', delay: !0, from: k(e)});
                    return c.$$willAnimate ? c : null
                  }();
                  if (!c && (F = v(), !F)) return C();
                  var g = c || F;
                  return {
                    start: function() {
                      function a() {
                        c && c.end()
                      }
                      var b, c = g.start();
                      c.done(function() {
                        c = null;
                        if (!F && (F = v()))
                          return c = F.start(), c.done(function() {
                            c = null;
                            C();
                            b.complete()
                          }),
                                 c;
                        C();
                        b.complete()
                      });
                      return b = new d({end: a, cancel: a})
                    }
                  }
                }
                function z(a, b, c, e) {
                  var f = oa(a, N), k = oa(b, N), h = [];
                  s(e, function(a) {
                    (a = C(c, a.out, a['in'])) && h.push(a)
                  });
                  if (f || k || 0 !== h.length) return {
                      start: function() {
                        function a() {
                          s(b, function(a) {
                            a.end()
                          })
                        }
                        var b = [];
                        f && b.push(f.start());
                        k && b.push(k.start());
                        s(h, function(a) {
                          b.push(a.start())
                        });
                        var c = new d({end: a, cancel: a});
                        d.all(b, function(a) {
                          c.complete(a)
                        });
                        return c
                      }
                    }
                }
                function oa(c) {
                  var d = c.element, e = c.options || {};
                  c.structural &&
                      (e.event = c.event, e.structural = !0,
                       e.applyClassesEarly = !0,
                       'leave' === c.event && (e.onDone = e.domOperation));
                  e.preparationClasses &&
                      (e.event = ba(e.event, e.preparationClasses));
                  c = a(d, e);
                  return c.$$willAnimate ? c : null
                }
                if (!k.animations && !k.transitions) return N;
                var H = Q[0].body;
                c = K(f);
                var u =
                    A(c.parentNode && 11 === c.parentNode.nodeType ||
                              H.contains(c) ?
                          c :
                          H);
                return function(a) {
                  return a.from && a.to ?
                      z(a.from, a.to, a.classes, a.anchors) :
                      oa(a)
                }
              }
            ]
          }
        ])
    .provider(
        '$$animateJs',
        [
          '$animateProvider',
          function(a) {
            this.$get = [
              '$injector', '$$AnimateRunner', '$$jqLite',
              function(b, c, d) {
                function f(c) {
                  c = Z(c) ? c : c.split(' ');
                  for (var d = [], f = {}, k = 0; k < c.length; k++) {
                    var s = c[k], z = a.$$registeredAnimations[s];
                    z && !f[s] && (d.push(b.get(z)), f[s] = !0)
                  }
                  return d
                }
                var k = aa(d);
                return function(a, b, d, x) {
                  function C() {
                    x.domOperation();
                    k(a, x)
                  }
                  function z(a, b, d, f, e) {
                    switch (d) {
                      case 'animate':
                        b = [b, f.from, f.to, e];
                        break;
                      case 'setClass':
                        b = [b, t, I, e];
                        break;
                      case 'addClass':
                        b = [b, t, e];
                        break;
                      case 'removeClass':
                        b = [b, I, e];
                        break;
                      default:
                        b = [b, e]
                    }
                    b.push(f);
                    if (a = a.apply(a, b))
                      if (Ea(a.start) && (a = a.start()), a instanceof c)
                        a.done(e);
                      else if (Ea(a))
                        return a;
                    return N
                  }
                  function A(a, b, d, e, f) {
                    var h = [];
                    s(e, function(e) {
                      var l = e[f];
                      l && h.push(function() {
                        var e, f, h = !1, k = function(a) {
                          h || (h = !0, (f || N)(a), e.complete(!a))
                        };
                        e = new c({
                          end: function() {
                            k()
                          },
                          cancel: function() {
                            k(!0)
                          }
                        });
                        f = z(l, a, b, d, function(a) {
                          k(!1 === a)
                        });
                        return e
                      })
                    });
                    return h
                  }
                  function H(a, b, d, e, f) {
                    var h = A(a, b, d, e, f);
                    if (0 === h.length) {
                      var k, q;
                      'beforeSetClass' === f ?
                          (k = A(a, 'removeClass', d, e, 'beforeRemoveClass'),
                           q = A(a, 'addClass', d, e, 'beforeAddClass')) :
                          'setClass' === f &&
                              (k = A(a, 'removeClass', d, e, 'removeClass'),
                               q = A(a, 'addClass', d, e, 'addClass'));
                      k && (h = h.concat(k));
                      q && (h = h.concat(q))
                    }
                    if (0 !== h.length)
                      return function(a) {
                        var b = [];
                        h.length && s(h, function(a) {
                          b.push(a())
                        });
                        b.length ? c.all(b, a) : a();
                        return function(a) {
                          s(b, function(b) {
                            a ? b.cancel() : b.end()
                          })
                        }
                      }
                  }
                  var u = !1;
                  3 === arguments.length && ta(d) && (x = d, d = null);
                  x = pa(x);
                  d ||
                      (d = a.attr('class') || '',
                       x.addClass && (d += ' ' + x.addClass),
                       x.removeClass && (d += ' ' + x.removeClass));
                  var t = x.addClass, I = x.removeClass, G = f(d), K, v;
                  if (G.length) {
                    var M, h;
                    'leave' === b ?
                        (h = 'leave', M = 'afterLeave') :
                        (h = 'before' + b.charAt(0).toUpperCase() + b.substr(1),
                         M = b);
                    'enter' !== b && 'move' !== b && (K = H(a, b, x, G, h));
                    v = H(a, b, x, G, M)
                  }
                  if (K || v) {
                    var q;
                    return {
                      $$willAnimate: !0, end: function() {
                        q ? q.end() :
                            (u = !0, C(), ha(a, x), q = new c, q.complete(!0));
                        return q
                      }, start: function() {
                        function b(c) {
                          u = !0;
                          C();
                          ha(a, x);
                          q.complete(c)
                        }
                        if (q) return q;
                        q = new c;
                        var d, f = [];
                        K && f.push(function(a) {
                          d = K(a)
                        });
                        f.length ? f.push(function(a) {
                          C();
                          a(!0)
                        }) :
                                   C();
                        v && f.push(function(a) {
                          d = v(a)
                        });
                        q.setHost({
                          end: function() {
                            u || ((d || N)(void 0), b(void 0))
                          },
                          cancel: function() {
                            u || ((d || N)(!0), b(!0))
                          }
                        });
                        c.chain(f, b);
                        return q
                      }
                    }
                  }
                }
              }
            ]
          }
        ])
    .provider('$$animateJsDriver', [
      '$$animationProvider',
      function(a) {
        a.drivers.push('$$animateJsDriver');
        this.$get = [
          '$$animateJs', '$$AnimateRunner',
          function(a, c) {
            function d(c) {
              return a(c.element, c.event, c.classes, c.options)
            }
            return function(a) {
              if (a.from && a.to) {
                var b = d(a.from), e = d(a.to);
                if (b || e) return {
                    start: function() {
                      function a() {
                        return function() {
                          s(d, function(a) {
                            a.end()
                          })
                        }
                      }
                      var d = [];
                      b && d.push(b.start());
                      e && d.push(e.start());
                      c.all(d, function(a) {
                        f.complete(a)
                      });
                      var f = new c({end: a(), cancel: a()});
                      return f
                    }
                  }
              } else
                return d(a)
            }
          }
        ]
      }
    ])
})(window, window.angular);
//# sourceMappingURL=angular-animate.min.js.map
