function fn() {
    var env = karate.env; // get java system property 'karate.env'
    karate.log('karate.env system property was:', env);
    if (!env) {
        env = 'development'; // a custom 'intelligent' default
    }
    var config = { // base config JSON
        dashboardUrl: 'https://development.wihp.ecdp.tech.ec.europa.eu',
        serviceUrl: 'https://development.wihp.ecdp.tech.ec.europa.eu/das',
        playgroundServiceUrl: 'https://development.wihp.ecdp.tech.ec.europa.eu/playground',
        tokenUrl: 'https://auth-development.wihp.ecdp.tech.ec.europa.eu/oauth2/token',
        authUrl: 'https://auth-development.wihp.ecdp.tech.ec.europa.eu/oauth2/auth',
        keycloakEnabled: false,
        cognitoEnabled: true,
        client_id: "dv9pcgqava8b6du311jikf9aj",
        client_secret: "6h8gfrai17as73h6i377na42b15m7j8m45c4uv4hld6m046fp54",
        scopes: "https://development.wihp.ecdp.tech.ec.europa.eu/api/das:full"
    };
    if (env === 'local') {
        config.dashboardUrl = 'http://host.docker.internal:4200'
        config.serviceUrl = 'http://host.docker.internal:8081'
        config.playgroundServiceUrl = 'http://host.docker.internal:8082'
        config.tokenUrl = 'http://keycloak:9080/auth/realms/jhipster/protocol/openid-connect/token'
        config.authUrl = 'http://keycloak:9080/auth/realms/jhipster/protocol/openid-connect/auth?client_id=web_app&response_type=code&redirect_uri=http%3A%2F%2Fhost.docker.internal%3A4200'
        config.keycloakEnabled = true
        config.cognitoEnabled= false
        config.client_id = "internal"
        config.client_secret = "internal"
        config.scopes = ""
    } else if (env === 'mr') {
        config.dashboardUrl = 'https://mr.wihp.ecdp.tech.ec.europa.eu'
        config.serviceUrl = 'https://mr.wihp.ecdp.tech.ec.europa.eu/das'
        config.playgroundServiceUrl = 'https://mr.wihp.ecdp.tech.ec.europa.eu/playground'
        config.tokenUrl = 'https://auth-development.wihp.ecdp.tech.ec.europa.eu/oauth2/token'
        config.authUrl = 'https://auth-development.wihp.ecdp.tech.ec.europa.eu/oauth2/auth?client_id=web_app&response_type=code&redirect_uri=http%3A%2F%2Fhost.docker.internal%3A4200'
        config.keycloakEnabled = false
        config.cognitoEnabled= true
        config.client_id = "dv9pcgqava8b6du311jikf9aj"
        config.client_secret = "6h8gfrai17as73h6i377na42b15m7j8m45c4uv4hld6m046fp54"
        config.scopes = "https://development.wihp.ecdp.tech.ec.europa.eu/api/das:full"
    }
    // don't waste time waiting for a connection or if servers don't respond within 5 seconds
    karate.configure('connectTimeout', 5000);
    karate.configure('readTimeout', 5000);
    karate.configure('driver', {
        type: 'chrome',
        showDriverLog: true,
        start: false,
        beforeStart: 'supervisorctl start ffmpeg',
        afterStop: 'supervisorctl stop ffmpeg',
        videoFile: '/tmp/karate.mp4'
    });
    return config;
}
