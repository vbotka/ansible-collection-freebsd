# -*- coding: utf-8 -*-
from __future__ import absolute_import, division, print_function
__metaclass__ = type

import pytest
from ansible_collections.vbotka.freebsd.plugins.filter.to_haproxy import to_haproxy
from ansible.errors import AnsibleFilterError


def test_to_haproxy_rendering():
    sample_data = {
        'global': {
            'log': '/var/run/log local0',
            'maxconn': 4096,
            'daemon': True
        },
        'defaults': {
            'mode': 'http',
            'retries': 3,
            'options': {
                'httplog': True
            },
            'timeouts': {
                'connect': '5s',
                'client': '30s',
                'server': '30s'
            }
        },
        'frontends': {
            'http_front': {
                'bind': '*:80',
                'acls': {
                    'is_api': 'path_beg /api'
                },
                'use_backends': [
                    {'backend': 'api_servers', 'condition': 'if is_api'}
                ],
                'default_backend': 'web_servers'
            }
        },
        'backends': {
            'web_servers': {
                'balance': 'roundrobin',
                'servers': {
                    'web1': {
                        'address': '10.0.1.10:8080',
                        'check': True,
                        'inter': '5s'
                    }
                }
            },
            'api_servers': {
                'balance': 'roundrobin',
                'servers': {
                    'api1': {
                        'address': '10.0.2.10:8080',
                        'check': True
                    }
                }
            }
        }
    }

    result = to_haproxy(sample_data)

    assert "global" in result
    assert "daemon" in result
    assert "mode http" in result
    assert "acl is_api path_beg /api" in result
    assert "use_backend api_servers if is_api" in result
    assert "default_backend web_servers" in result
    assert "server web1 10.0.1.10:8080 check inter 5s" in result


def test_to_haproxy_invalid_input():
    with pytest.raises(AnsibleFilterError, match="to_haproxy expects a dictionary"):
        to_haproxy(["not", "a", "dictionary"])
