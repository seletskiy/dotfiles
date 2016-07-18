var path = 'file:///home/s.seletskiy/.config/surfingkeys.js'

// Do not forget to enable 'Allow access to the URLs' for access to file://
// Yandex: browser://extensions
// Chrome: chrome://extensions
// http://i.imgur.com/rOO37rm.png

var openLink = function(url) {
    return function(){
        runtime.command({
            action: 'openLink',
            tab: {
                tabbed: true
            },
            position: runtime.settings.newTabPosition,
            url: url
        })
    }
}

var favorites = function(prefix, urls) {
    for (var key in urls) {
        mapkey(
            prefix + key,
            'favorite:' + urls[key],
            openLink('http://' + urls[key])
        )
    }
}

var sourceSettings = function() {
    runtime.command({
            action: 'loadSettingsFromUrl',
            url: path,
    });
    console.log('source ' + path)
}

var pasteLink = function() {
    Normal.getContentFromClipboard(function(buffer) {
        window.location.href = buffer.data
    })
}

settings.tabsThreshold = 0 // omnibar instead of table
settings.smoothScroll = false

settings.blacklist = {
    'https://mail.google.com': 1
}

mapkey(';', 'tabswitcher',     Normal.chooseTab)
mapkey('=', 'source settings', sourceSettings)
mapkey('p', 'paste link',      pasteLink)

map('F', 'af')
map('o', 'go')

favorites('g', {
    g: 'gmail.com',
    v: 'vk.com',
    t: 'twitter.com',
    h: 'github.com',
    y: 'news.ycombinator.com',
    p: 'postdevops.slack.com',
    n: 'ngs-team.slack.com',
})
