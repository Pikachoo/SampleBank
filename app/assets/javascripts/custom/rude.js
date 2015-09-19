function debug(variable)
{
	console.log(variable);
}

var rude =
{
	array:
	{
		unique: function(array)
		{
			function _unique(value, index, self)
			{
				return self.indexOf(value) === index;
			}

			return array.filter(_unique);
		}
	},

	string:
	{
		starts_with: function(string, substring)
		{
			return string.indexOf(substring) === 0;
		}
	},

	semantic:
	{
		init:
		{
			dropdown: function()
			{
				$(function() {
					$('.ui.dropdown').dropdown();
				});
			},

			checkbox: function()
			{
				$(function() {
					$('.ui.checkbox').checkbox();
				});
			},

			rating: function()
			{
				$(function() {
					$('.ui.rating').rating();
				});
			}
		}
	},

	jquery:
	{
		escape:
		{
			selector: function(selector)
			{
				if (selector)
				{
					return selector.replace(/([ #;?%&,.+*~\':"!^$[\]()=>|\/@])/g,'\\$1');
				}

				return selector;
			}
		}
	},

	time:
	{
		to:
		{
			string: function(milliseconds)
			{
				var minutes = Math.floor(milliseconds / 60000);
				var seconds = Math.floor((milliseconds - (minutes * 60000)) / 1000);

				if (seconds < 10) { seconds = '0' + seconds; }
				if (minutes < 10) { minutes = '0' + minutes; }

				return minutes + ':' + seconds;
			}
		}
	},

	base64:
	{
		decode: function(s)
		{
			var e = {}, i, b = 0, c, x, l = 0, a, r = '', w = String.fromCharCode, L = s.length;

			var A = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';

			for (i = 0; i < 64; i++)
			{
				e[A.charAt(i)] = i;
			}

			for (x = 0; x < L; x++)
			{
				c = e[s.charAt(x)];
				b = (b << 6) + c;
				l += 6;

				while (l >= 8)
				{
					((a = (b >>> (l -= 8)) & 0xff) || (x < (L - 2))) && (r += w(a));
				}
			}

			return r;
		}
	},

	url:
	{
		parse: function(url)
		{
			var parser = document.createElement('a');

			parser.href = url;

			return parser; // http://example.com:3000/pathname/?search=test#hash
			//
			// parser.protocol => "http:"
			// parser.host     => "example.com:3000"
			// parser.hostname => "example.com"
			// parser.port     => "3000"
			// parser.pathname => "/pathname/"
			// parser.hash     => "#hash"
			// parser.search   => "?search=test"
		},

		reload: function()
		{
			location.reload();
		},

		redirect: function(url)
		{
			window.location.replace(url);
		},

		host: function()
		{
			return window.location.host;
		},

		param:
		{
			add: function(key, value)
			{
				key   = encodeURIComponent(key);
				value = encodeURIComponent(value);

				var kvp = document.location.search.substr(1).split('&');

				if (kvp == '')
				{
					document.location.search = '?' + key + '=' + value;
				}
				else
				{
					var i = kvp.length;
					var x;

					while (i--)
					{
						x = kvp[i].split('=');

						if (x[0] == key)
						{
							x[1] = value;
							kvp[i] = x.join('=');

							break;
						}
					}

					if (i < 0) { kvp[kvp.length] = [key, value].join('='); }

					// this will reload the page, it's likely better to store this until finished

					document.location.search = kvp.join('&');
				}
			},

			get: function(key)
			{
				return location.search.split(key + '=')[1] ? location.search.split(key + '=')[1] : '';
			}
		}
	}
};