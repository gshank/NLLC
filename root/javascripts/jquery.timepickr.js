/*
  jQuery utils - 0.6.2
  http://code.google.com/p/jquery-utils/

  (c) Maxime Haineault <haineault@gmail.com> 
  http://haineault.com

  MIT License (http://www.opensource.org/licenses/mit-license.php

*/

(function($){
     $.extend($.expr[':'], {
        // case insensitive version of :contains
        icontains: function(a,i,m){return (a.textContent||a.innerText||jQuery(a).text()||"").toLowerCase().indexOf(m[3].toLowerCase())>=0;}
    });
	$.extend({ 

        // Redirect to a specified url
        redirect: function(url) {
            return window.location.href = url;
        },

        // Stop event shorthand
        stop: function(e, preventDefault, stopPropagation) {
            preventDefault  && e.preventDefault();
            stopPropagation && e.stopPropagation();
            return preventDefault && false || true;
        },

        // Returns the basename of a path
        basename: function(path) {
            var t = path.split('/');
            return t[t.length] == '' && s || t.slice(0, t.length).join('/');
        },

        // Returns the filename of a path
        filename: function(path) {
            return path.split('/').pop();
        }, 
        
        // Returns true if an object is a RegExp
		isRegExp: function(o) {
			return o && o.constructor.toString().indexOf('RegExp()') != -1 || false;
		},
        
        // Returns true if an object is an array
		isArray: function(o) {
			return o && o.constructor.toString().indexOf('Array()') != -1 || false;
		},
        
        // Convert input to currency (two decimal fixed number)
		toCurrency: function(i) {
			i = parseFloat(i, 10).toFixed(2);
			return (i=='NaN') ? '0.00' : i;
		},

        // Returns a range object
        // Author: Matthias Miller
        // Site:   http://blog.outofhanwell.com/2006/03/29/javascript-range-function/
        range:  function() {
            if (!arguments.length) { return []; }
            var min, max, step;
            if (arguments.length == 1) {
                min  = 0;
                max  = arguments[0]-1;
                step = 1;
            }
            else {
                // default step to 1 if it's zero or undefined
                min  = arguments[0];
                max  = arguments[1]-1;
                step = arguments[2] || 1;
            }
            // convert negative steps to positive and reverse min/max
            if (step < 0 && min >= max) {
                step *= -1;
                var tmp = min;
                min = max;
                max = tmp;
                min += ((max-min) % step);
            }
            var a = [];
            for (var i = min; i <= max; i += step) { 
                    a.push(i);
            }
            return a;
        }
	});

	$.extend($.fn, { 
        // Select a text range in a textarea
        selectRange: function(start, end) {
            // use only the first one since only one input can be focused
            if ($(this).get(0).createTextRange) {
                var range = $(this).get(0).createTextRange();
                range.collapse(true);
                range.moveEnd('character',   end);
                range.moveStart('character', start);
                range.select();
            }
            else if ($(this).get(0).setSelectionRange) {
                $(this).bind('focus', function(e){
                    e.preventDefault();
                }).get(0).setSelectionRange(start, end);
            }
            return $(this);
        }
	});
})(jQuery);
/*
  jQuery strings - 0.1a
  http://code.google.com/p/jquery-utils/
  
  (c) Maxime Haineault <haineault@gmail.com>
  http://haineault.com   

  MIT License (http://www.opensource.org/licenses/mit-license.php)

  Implementation of Python3K advanced string formatting
  http://www.python.org/dev/peps/pep-3101/

  Documentation: http://code.google.com/p/jquery-utils/wiki/StringFormat
  
*/
(function($){
    var conversion = {
        // tries to translate any objects type into string gracefully
        __repr: function(i){
            switch(this.__getType(i)) {
                case 'array':case 'date':case 'number':
                    return i.toString();
                case 'object': 
                    var o = [];
                    for (x=0; x<i.length; i++) { o.push(i+': '+ this.__repr(i[x])); }
                    return o.join(', ');
                case 'string': 
                    return i;
                default: 
                    return i;
            }
        },
        // like typeof but less vague
        __getType: function(i) {
            if (!i || !i.constructor) { return typeof(i); }
            var match = i.constructor.toString().match(/Array|Number|String|Object|Date/);
            return match && match[0].toLowerCase() || typeof(i);
        },
        //+ Jonas Raoni Soares Silva
        //@ http://jsfromhell.com/string/pad [v1.0]
        __pad: function(str, l, s, t){
            var p = s || ' ';
            var o = str;
            if (l - str.length > 0) {
                o = new Array(Math.ceil(l / p.length)).join(p).substr(0, t = !t ? l : t == 1 ? 0 : Math.ceil(l / 2)) + str + p.substr(0, l - t);
            }
            return o;
        },
        __getInput: function(arg, args) {
             var key = arg.getKey();
            switch(this.__getType(args)){
                case 'object': // Thanks to Jonathan Works for the patch
                    var keys = key.split('.');
                    var obj = args;
                    for(var subkey = 0; subkey < keys.length; subkey++){
                        obj = obj[keys[subkey]];
                    }
                    if (typeof(obj) != 'undefined') {
                        if (conversion.__getType(obj) == 'array') {
                            return arg.getFormat().match(/\.\*/) && obj[1] || obj;
                        }
                        return obj;
                    }
                    else {
                        // TODO: try by numerical index                    
                    }
                break;
                case 'array': 
                    key = parseInt(key, 10);
                    if (arg.getFormat().match(/\.\*/) && typeof args[key+1] != 'undefined') { return args[key+1]; }
                    else if (typeof args[key] != 'undefined') { return args[key]; }
                    else { return key; }
                break;
            }
            return '{'+key+'}';
        },
        __formatToken: function(token, args) {
            var arg   = new Argument(token, args);
            return conversion[arg.getFormat().slice(-1)](this.__getInput(arg, args), arg);
        },

        // Signed integer decimal.
        d: function(input, arg){
            var o = parseInt(input, 10); // enforce base 10
            var p = arg.getPaddingLength();
            if (p) { return this.__pad(o.toString(), p, arg.getPaddingString(), 0); }
            else   { return o; }
        },
        // Signed integer decimal.
        i: function(input, args){ 
            return this.d(input, args);
        },
        // Unsigned octal
        o: function(input, arg){ 
            var o = input.toString(8);
            if (arg.isAlternate()) { o = this.__pad(o, o.length+1, '0', 0); }
            return this.__pad(o, arg.getPaddingLength(), arg.getPaddingString(), 0);
        },
        // Unsigned decimal
        u: function(input, args) {
            return Math.abs(this.d(input, args));
        },
        // Unsigned hexadecimal (lowercase)
        x: function(input, arg){
            var o = parseInt(input, 10).toString(16);
            o = this.__pad(o, arg.getPaddingLength(), arg.getPaddingString(),0);
            return arg.isAlternate() ? '0x'+o : o;
        },
        // Unsigned hexadecimal (uppercase)
        X: function(input, arg){
            return this.x(input, arg).toUpperCase();
        },
        // Floating point exponential format (lowercase)
        e: function(input, arg){
            return parseFloat(input, 10).toExponential(arg.getPrecision());
        },
        // Floating point exponential format (uppercase)
        E: function(input, arg){
            return this.e(input, arg).toUpperCase();
        },
        // Floating point decimal format
        f: function(input, arg){
            return this.__pad(parseFloat(input, 10).toFixed(arg.getPrecision()), arg.getPaddingLength(), arg.getPaddingString(),0);
        },
        // Floating point decimal format (alias)
        F: function(input, args){
            return this.f(input, args);
        },
        // Floating point format. Uses exponential format if exponent is greater than -4 or less than precision, decimal format otherwise
        g: function(input, arg){
            var o = parseFloat(input, 10);
            return (o.toString().length > 6) ? Math.round(o.toExponential(arg.getPrecision())): o;
        },
        // Floating point format. Uses exponential format if exponent is greater than -4 or less than precision, decimal format otherwise
        G: function(input, args){
            return this.g(input, args);
        },
        // Single character (accepts integer or single character string). 	
        c: function(input, args) {
            var match = input.match(/\w|\d/);
            return match && match[0] || '';
        },
        // String (converts any JavaScript object to anotated format)
        r: function(input, args) {
            return this.__repr(input);
        },
        // String (converts any JavaScript object using object.toString())
        s: function(input, args) {
            return input.toString && input.toString() || ''+input;
        }
    };

    var Argument = function(arg, args) {
        this.__arg  = arg;
        this.__args = args;
        this.__max_precision = parseFloat('1.'+ (new Array(32)).join('1'), 10).toString().length-3;
        this.__def_precision = 6;
        this.getString = function(){
            return this.__arg;
        };
        this.getKey = function(){
            return this.__arg.split(':')[0];
        };
        this.getFormat = function(){
            var match = this.getString().split(':');
            return (match && match[1])? match[1]: 's';
        };
        this.getPrecision = function(){
            var match = this.getFormat().match(/\.(\d+|\*)/g);
            if (!match) { return this.__def_precision; }
            else {
                match = match[0].slice(1);
                if (match != '*') { return parseInt(match, 10); }
                else if(conversion.__getType(this.__args) == 'array') {
                    return this.__args[1] && this.__args[0] || this.__def_precision;
                }
                else if(conversion.__getType(this.__args) == 'object') {
                    return this.__args[this.getKey()] && this.__args[this.getKey()][0] || this.__def_precision;
                }
                else { return this.__def_precision; }
            }
        };
        this.getPaddingLength = function(){
            var match = false;
            if (this.isAlternate()) {
                match = this.getString().match(/0?#0?(\d+)/);
                if (match && match[1]) { return parseInt(match[1], 10); }
            }
            match = this.getString().match(/(0|\.)(\d+|\*)/g);
            return match && parseInt(match[0].slice(1), 10) || 0;
        };
        this.getPaddingString = function(){
            var o = '';
            if (this.isAlternate()) { o = ' '; }
            // 0 take precedence on alternate format
            if (this.getFormat().match(/#0|0#|^0|\.\d+/)) { o = '0'; }
            return o;
        };
        this.getFlags = function(){
            var match = this.getString().matc(/^(0|\#|\-|\+|\s)+/);
            return match && match[0].split('') || [];
        };
        this.isAlternate = function() {
            return !!this.getFormat().match(/^0?#/);
        };
    };

    var arguments2Array = function(args, shift) {
        var o = [];
        for (l=args.length, x=(shift || 0)-1; x<l;x++) { o.push(args[x]); }
        return o;
    };

    var format = function(str, args) {
        var end    = 0;
        var start  = 0;
        var match  = false;
        var buffer = [];
        var token  = '';
        var tmp    = (str||'').split('');
        for(start=0; start < tmp.length; start++) {
            if (tmp[start] == '{' && tmp[start+1] !='{') {
                end   = str.indexOf('}', start);
                token = tmp.slice(start+1, end).join('');
                buffer.push(conversion.__formatToken(token, (typeof arguments[1] != 'object')? arguments2Array(arguments, 2): args || []));
            }
            else if (start > end || buffer.length < 1) { buffer.push(tmp[start]); }
        }
        return (buffer.length > 1)? buffer.join(''): buffer[0];
    };

    var calc = function(str, args) {
        return eval(format(str, args));
    };

    $.extend({
        // Format/sprintf functions
        format: format,
        calc:   calc,
        strConversion: conversion,
        repeat:  function(s, n) { return new Array(n+1).join(s); },
        UTF8encode: function(s) { return unescape(encodeURIComponent(s)); },
        UTF8decode: function(s) { return decodeURIComponent(escape(s)); }
    });

})(jQuery);
/*
  jQuery ui.dropslide - 0.3
  http://code.google.com/p/jquery-utils/

  (c) Maxime Haineault <haineault@gmail.com> 
  http://haineault.com

  MIT License (http://www.opensource.org/licenses/mit-license.php

*/

(function($) {
    $.widget('ui.dropslide', $.extend({}, $.ui.mouse, {
        getter: 'showLevel showNextLevel',
        init: function() {
            var next     = this.element.next();
            this.wrapper = next.hasClass('ui-dropslide') && next || this.options.tree || false;

            if (this.wrapper) {
                this.element.bind(this.options.trigger +'.dropslide', onActivate);
                this.wrapper
                    .data('dropslide', this)
                    .css({width:this.options.width})
                    .find('li, li ol li').bind('mouseover.dropslide', onLiMouseover)
                               .bind('click.dropslide',     onLiClick).end()
                    .find('ol').bind('mousemove.dropslide', onOlMousemove).hide();
            }
        },
        // show specified level, id is the DOM position
        showLevel: function(id) {
            var ols = this.wrapper.find('ol');
            var ds  = this;
            if (id == 0) {            
                ols.eq(0).css('left', this.element.position().left);
            }
            setTimeout(function() {
                ols.removeClass('active').eq(id).addClass('active').show(ds.options.animSpeed);
            }, ds.options.showDelay);
        },

        // guess what it does
        showNextLevel: function() {
            if (this.is2d()) {
                this.wrapper.find('ol.active')
                    .removeClass('active')
                    .next('ol').addClass('active').show(this.options.animSpeed);
            }
            else {
                this.wrapper.find('ol.active').removeClass('active').find('li.hover > ol').addClass('active').show(this.options.animSpeed);
            }
        },

        getSelection: function(level) {
            if (level) {
                return this.wrapper.find('ol').eq(level).find('li span.ui-hover-state');
            }
            else {
                return $.makeArray(this.wrapper.find('span.ui-hover-state')
                    .map(function() { 
                         return $(this).text(); 
                    }));
            }
        },

        // essentially reposition each ol
        redraw: function() {
            redraw(this);
        },

        // show level 0 (shortcut)
        show: function(e) {
            this.showLevel(0);
        },

        // hide all levels
        hide: function() {
            var dropslide = this;
            setTimeout(function() {
                dropslide.wrapper.find('ol').hide();
            }, dropslide.options.hideDelay);
        },

        // determine dropdown type
        is2d: function() {
            return !this.is3d();
        },

        is3d: function() {
            return !!this.wrapper.find('ol > li > ol').get(0);
        },

        activate: function(e) {
            this.element.focus();
            this.show(this.options.animSpeed);
        },
                  
        destroy: function(e) {
            this.wrapper.remove();
        }
    }));

    //$.ui.dropslide.getter = '';

    $.ui.dropslide.defaults = {
        // options
        tree:    false,
        trigger: 'mouseover',
        top:     6,
        left:    0,
        showDelay: 0,
        hideDelay: 0,
        animSpeed: 0,
        // events
        select:  function() {},
        click:   function(e, dropslide) {
            dropslide.hide();
        }
    }

    function onActivate(e) {
        var dropslide = getDropSlide(this);
        dropslide.show();
    }

    function onLiMouseover(e) {
        var dropslide = getDropSlide(this);
        $(this).siblings().removeClass('hover')
            .find('ol').hide().end()
            .find('span').removeClass('ui-hover-state').end();

        $(this).find('ol').show().end().addClass('hover').children(0).addClass('ui-hover-state');
        dropslide.showNextLevel();
    }

    function onLiClick(e) {
        var dropslide = getDropSlide(this);
        $(dropslide.element).triggerHandler('dropslideclick',  [e, dropslide], dropslide.options.click); 
        $(dropslide.element).triggerHandler('select',          [e, dropslide], dropslide.options.select); 
    }
    
    function redraw(dropslide) {
        var prevLI = false;
        var prevOL = false;
        var nextOL = false;
        var pos    = false;
        var offset = dropslide.element.position().left + dropslide.options.left;

        var ols    = $(dropslide.wrapper).find('ol');

        $(dropslide.wrapper).css({
            top: dropslide.element.position().top + dropslide.element.height() + dropslide.options.top,
            left: dropslide.element.position().left
        });
        
        // reposition each ol
        ols.each(function(i) {
            prevOL = $(this).prevAll('ol:visible:first');
            // without the try/catch I often get a 
            // Error: "Could not convert JavaScript argument arg 0 ..."
            try {
                if (prevOL.get(0)) {
                    prevLI = prevOL.find('li.hover, li:first').eq(0);
                    $(this).css('margin-left', prevLI.position().left);
                }
            } catch(e) {};
        });
    
    }

    function onOlMousemove(e) {
        var dropslide = getDropSlide(this);
        return redraw(dropslide);
    }
    
    function getDropSlide(el) {
        return $(el).data('dropslide')
                || $(el).parents('.ui-dropslide').data('dropslide');
    };
})(jQuery);
/*
  jQuery ui.timepickr - 0.6.2
  http://code.google.com/p/jquery-utils/

  (c) Maxime Haineault <haineault@gmail.com> 
  http://haineault.com

  MIT License (http://www.opensource.org/licenses/mit-license.php

  Note: if you want the original experimental plugin checkout the rev 224 

  Dependencies
  ------------
  - jquery.utils.js
  - jquery.strings.js
  - ui.dropslide.js

*/

(function($) {
    function createButton(i, format, className) {
        var o  = format && $.format(format, i) || i;
        var cn = className && 'ui-timepickr '+ className || 'ui-timepickr';
        return $('<li class="ui-reset" />').addClass(cn).data('id', i).append($('<span class="ui-default-state" />').text(o));
    }

    function createRow(obj, format, className) {
        var row = $('<ol class="ui-clearfix ui-reset" />');
        for (var x in obj) {
            row.append(createButton(obj[x], format || false, className || false));
        }
        return row;
    }
    
    function getTimeRanges(options) {
        var o = [];
        if (options.prefix && options.convention === 24) {
            o.push(createRow(options.prefix, false, 'prefix'));
        }
        if (options.hours) {
            var h = (options.convention === 24) && $.range(0, 24) || $.range(1, 13);

            o.push(createRow(h, '{0:0.2d}', 'hour'));
        }
        if (options.minutes) {
            o.push(createRow(options.rangeMin, '{0:0.2d}', 'minute'));
        }
        if (options.seconds) {
            o.push(createRow(options.rangeSec, '{0:0.2d}', 'second'));
        }
        if (options.suffix && options.convention === 12) {
            o.push(createRow(options.suffix, false, 'suffix'));
        }
        return o;
    }

    function buildMenu (options) {
        var ranges = getTimeRanges(options);
        var menu   = $('<span class="ui-reset ui-dropslide ui-component">');
        //if () {options.convention}
        for (var x in ranges) {
            menu.append(ranges[x]);
        }
        return menu;
    }

    $.widget('ui.timepickr', {
        init: function() {
            var menu    = buildMenu(this.options);
            var element = this.element;
            element.data('timepickr.initialValue', element.val());
            menu.insertAfter(this.element);
            element
                .addClass('ui-timepickr')
                .dropslide(this.options.dropslide)
                .bind('select', this.select);
            
            element.blur(function(e) {
                $(this).dropslide('hide');
                $(this).val($(this).data('timepickr.initialValue'));
            });

            if (this.options.val) {
                element.val(this.options.val);
            }

            if (this.options.handle) {
                $(this.options.handle).click(function() {
                    $(element).dropslide('show');
                });
            }

            if (this.options.resetOnBlur) {
                menu.find('li > span').bind('mousedown.timepickr', function(){
                    $(element).data('timepickr.initialValue', $(element).val()); 
                });
            }

            if (this.options.updateLive) {
                menu.find('li').bind('mouseover.timepickr', function() {
                    $(element).timepickr('update'); 
                });
            }

            // TODO: remember selection
            var hrs = menu.find('ol:eq(1)').find('li:first').addClass('hover').find('span').addClass('ui-hover-state').end().end();
            var min = menu.find('ol:eq(2)').find('li:first').addClass('hover').find('span').addClass('ui-hover-state').end().end();
            var sec = menu.find('ol:eq(3)').find('li:first').addClass('hover').find('span').addClass('ui-hover-state').end().end();

            if (this.options.convention === 24) {
                var day        = menu.find('ol:eq(0) li:eq(0)');
                var night      = menu.find('ol:eq(0) li:eq(1)');
                var dayHours   = hrs.find('li').slice(0, 12);
                var nightHours = hrs.find('li').slice(12, 24);
                var index      = 0;
                var selectHr   = function(id) {
                    hrs.find('li').removeClass('hover');
                    hrs.find('span').removeClass('ui-hover-state');
                    hrs.find('li').eq(id).addClass('hover').find('span').addClass('ui-hover-state')
                };

                day.mouseover(function() {
                    nightHours.hide();
                    dayHours.show(0);
                    index = hrs.find('li.hover').data('id') || hrs.find('li:first').data('id');
                    selectHr(index > 11 && index - 12 || index);
                    element.dropslide('redraw');
                });

                night.mouseover(function() {
                    dayHours.hide();
                    nightHours.show(0);
                    index = hrs.find('li.hover').data('id') || hrs.find('li:first').data('id');
                    selectHr(index < 12 && index + 12 || index);
                    element.dropslide('redraw');
                });
            }
            element.dropslide('redraw');
            element.data('timepickr', this);
        },

        update: function() {
            var frmt = this.options.convention === 24 && 'format24' || 'format12';
            var val = {
                h: this.getValue('hour'),
                m: this.getValue('minute'),
                s: this.getValue('second'),
                prefix: this.getValue('prefix'),
                suffix: this.getValue('suffix')
            };
            var o = $.format(this.options[frmt], val);

            $(this.element).val(o);
        },

        select: function(e) {
            var dropslide = $(this).data('dropslide');
            $(dropslide.element).timepickr('update');
            e.stopPropagation();
        },

        getHour: function(selection) {
            return this.getValue('hour');
        },

        getMinute: function(selection) {
            return this.getValue('minute');
        },

        getSecond: function(selection) {
            return this.getValue('second');
        },

        getValue: function(type) {
            return $('.ui-timepickr.'+ type +'.hover', this.element.next()).text();
        },
        
        activate: function() {
            this.element.dropslide('activate');
        },

        destroy: function() {
            this.element.dropslide('destroy');
        }
        
    });

    //$.ui.timepickr.getter = '';

    $.ui.timepickr.defaults = {
        convention:  24, // 24, 12
        dropslide:   { trigger: 'focus' },
        format12:    '{h:02.d}:{m:02.d} {suffix:s}',
        format24:    '{h:02.d}:{m:02.d}',
        handle:      false,
        hours:       true,
        minutes:     true,
        seconds:     false,
        prefix:      ['am', 'pm'],
        suffix:      ['am', 'pm'],
        rangeMin:    ['00', '15', '30', '45'],
        rangeSec:    ['00', '15', '30', '45'],
        updateLive:  true,
        resetOnBlur: true,
        val:         false
    };
 })(jQuery);
