package ar.com.bambu.wpromo;

import ar.com.bambu.wpromo.services.Promociones;
import org.glassfish.jersey.message.GZipEncoder;
import org.glassfish.jersey.server.ResourceConfig;
import org.glassfish.jersey.server.filter.EncodingFilter;
import org.springframework.context.annotation.Configuration;

@Configuration
public class JerseyConfig extends ResourceConfig {
    public JerseyConfig() {
        register(Promociones.class);
        EncodingFilter.enableFor(this, GZipEncoder.class);
    }
}
