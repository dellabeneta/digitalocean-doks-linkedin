from flask import Flask, render_template_string
import socket

app = Flask(__name__)

@app.route('/')
def get_hostname():
    hostname = socket.gethostname()

    auto_refresh_meta = '<meta http-equiv="refresh" content="2">'

    return render_template_string(
        f'{auto_refresh_meta}'
        '<style>'
        'body {'
        '    overflow-x: hidden;'
        '}'
        '</style>'
        '<div style="background-color: black; color: white; padding: 10px; width: 100%; text-align: center; font-size: 42px; font-family: Montserrat, sans-serif; position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%);">'
        f'Hostname: {hostname}'
        '</div>'
        '<div style="background-color: #f0f0f0; color: black; padding: 10px; width: 100%; text-align: center; font-size: 24px; position: fixed; top: 0; left: 0;">'
        '<div id="countdown">'
        'Esta página será atualizada em <span id="countdown-span">2</span> segundos'
        '</div>'
        '</div>'
        '<script>'
        'var seconds = 2;'
        'function countdown() {'
        '    document.getElementById("countdown-span").innerHTML = seconds;'
        '    if (seconds == 0) {'
        '        window.location.reload();'
        '    } else {'
        '        seconds--;'
        '        setTimeout(countdown, 1000);'
        '    }'
        '}'
        'countdown();'
        '</script>'
    )

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)