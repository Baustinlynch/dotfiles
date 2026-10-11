#!/bin/bash
profile=$(powerprofilesctl get)
case "$profile" in
  power-saver)  echo '{"text": "🔋 Saver", "class": "power-saver"}' ;;
  balanced)     echo '{"text": "⚖ Balanced", "class": "balanced"}' ;;
  performance)  echo '{"text": "🚀 Perf", "class": "performance"}' ;;
esac

