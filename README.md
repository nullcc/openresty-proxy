# OpenResty Proxy

- HTTP
- Web Socket

## Usage

1. Create [domain-name].conf in `config/domains` directory.
2. Copy content from `sample.com.conf` to the new file.
3. Modify `server_name`, `ssl_certificate`, `ssl_certificate_key` and `ssl_trusted_certificate` directives.
4. Use `bin/generate_certificate.sh` to make a certificate for the new domain.
5. Run `sh bin/start.sh`. 
