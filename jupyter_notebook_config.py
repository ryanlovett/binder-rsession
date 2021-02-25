c.ServerProxy.servers = {
  'myserver': {
    'command': ['python', 'myserver.py'],
    'port': 9000,
    'launcher_entry': {
      'title': 'My Server'
    },
    'proxy_headers': {
      'X-RStudio-Root-Path': '{base_url}rstudio/'
    }
  }
}
