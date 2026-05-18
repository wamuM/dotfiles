function upc-vpn {
    xdg-open "https://myupclink.upc.edu:443/remote/saml/start?redirect=1" &
    sudo openfortivpn --saml-login myupclink.upc.edu:443 --username marcel.mula
}
