#!/usr/bin/env bash
curl -i -X POST http://127.0.0.1:8083/fedmgr --data '{"action": "PAUSE"}' -H "Content-Type: application/json"