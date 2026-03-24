source /usr/share/cachyos-fish-config/cachyos-config.fish

# Percorso del tema oh-my-posh
set -l THEME_PATH ~/.config/oh-my-posh/custom-angularic.omp.json

# Inizializzazione oh-my-posh
if command -v oh-my-posh > /dev/null
    # La nuova riga dopo ogni interazione è gestita automaticamente da oh-my-posh
    # grazie alla configurazione nel file JSON
    oh-my-posh init fish --config $THEME_PATH | source
end
