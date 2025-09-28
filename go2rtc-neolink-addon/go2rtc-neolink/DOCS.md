# go2rtc + neolink (Reolink 2-way)

Add-on Home Assistant che esegue **go2rtc** e abilita il **backchannel audio** (parla) per campanelli/telecamere **Reolink** tramite `neolink talk`.

## Configurazione (in Add-on → Configuration)
```yaml
camera_ip: "192.168.1.50"
username: "admin"
password: "changeme"
stream: "sub"   # "sub" consigliato per tablet (bassa latenza). "main" = alta qualità.
extra_streams: ""  # opzionale: YAML aggiuntivo da appendere sotto 'streams:'
```

Dopo l'avvio:
- Interfaccia **go2rtc** su `http://<IP_HA>:1984/`
- Stream WebRTC/RTSP creato: `doorbell_sub` (o `doorbell_main`)

## Lovelace (WebRTC Camera)
Installa la card **WebRTC Camera** (HACS, AlexxIT) e aggiungi:
```yaml
type: custom:webrtc-camera
url: webrtc://doorbell_sub
ui: true
background: true
muted: false
```
Il pulsante **microfono** appare quando il backchannel è attivo. **Serve HTTPS** sulla dashboard per i permessi del microfono (policy browser).

## Note
- L'add-on genera `/etc/neolink.toml` e `/data/go2rtc.yaml` automaticamente dai campi di configurazione.
- Stream origine: Reolink **HTTP-FLV** (bassa latenza) con fallback **RTSP**.
- Se l'audio in uscita non funziona, controlla i log dell’add-on (lato `neolink talk`) e che la cam abbia **Audio** abilitato.
