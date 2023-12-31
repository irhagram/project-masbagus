function onPlayStart(name, delegate, imporant)
    globalOptionsCache[name].onPlayStart = delegate
    globalOptionsCache[name].imporant = imporant
end

exports('onPlayStart', onPlayStart)

function onPlayEnd(name, delegate)
    globalOptionsCache[name].onPlayEnd = delegate
end

exports('onPlayEnd', onPlayEnd)

function onLoading(name, delegate)
    globalOptionsCache[name].onLoading = delegate
end

exports('onLoading', onLoading)

function onPlayPause(name, delegate)
    globalOptionsCache[name].onPlayPause = delegate
end

exports('onPlayPause', onPlayPause)

function onPlayResume(name, delegate)
    globalOptionsCache[name].onPlayResume = delegate
end

exports('onPlayResume', onPlayResume)

function onPlayStartSilent(name, delegate)
    globalOptionsCache[name].onPlayStartSilent = delegate
end