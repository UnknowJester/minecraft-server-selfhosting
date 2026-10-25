# Minecraft NeoForge Server Launcher

Launcher generico e interattivo per un server Minecraft NeoForge costruito a partire da un'istanza Prism Launcher.

Nessun modpack è preimpostato: all'avvio lo script elenca le istanze Prism disponibili e l'utente sceglie quale usare.

## Contenuto

- `AVVIA SERVER.bat` — avvia il server con la cartella `world` attuale.
- `SELEZIONA MONDO.bat` / `seleziona-mondo.ps1` — seleziona interattivamente l'istanza Prism (modpack) e un mondo del client, lo copia nel server (con backup del precedente) e avvia il server.

## Requisiti

- Java 21.
- Prism Launcher con almeno un'istanza (modpack) installata.
- Server NeoForge costruito a partire dall'istanza scelta (vedi "Preparazione server").

## Preparazione server (prima volta)

1. Crea la cartella del server e installa NeoForge (versione compatibile con il modpack scelto).
2. Copia nella cartella del server: `mods`, `config`, `defaultconfigs`, `kubejs` (se presente) dall'istanza Prism.
3. Sposta i mod solo-client (es. Sodium, Xaero Minimap/WorldMap) in una cartella `mods-disabled` per evitare crash del server.
4. Imposta la RAM in `user_jvm_args.txt` (es. `-Xms4G -Xmx6G`).
5. Copia in questa cartella i file di questo repository.
6. Esegui `SELEZIONA MONDO.bat`: scegli istanza e mondo, poi il server si avvia.

## Configurazione

| Variabile d'ambiente | Default | Descrizione |
|---|---|---|
| `PRISM_INSTANCES_ROOT` | `%APPDATA%\PrismLauncher\instances` | Cartella radice delle istanze Prism |
| `SERVER_DIR` | cartella dello script | Cartella del server |

## Note

- Il server completo (mods, librerie, mondo, cache) non è incluso: è grande e contiene binari.
- Lo script crea un backup `world_backup_<timestamp>` prima di sostituire il mondo.
- I mondi del client restano intatti nella cartella `saves` di Prism.
- L'utente sceglie l'istanza e il mondo a runtime: nessun modpack è hardcoded.
