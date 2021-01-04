package ar.com.bambu.wpromo.services;

import org.springframework.core.io.ByteArrayResource;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpServletResponse;
import javax.ws.rs.Consumes;
import javax.ws.rs.PUT;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import javax.xml.XMLConstants;
import javax.xml.transform.Result;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import java.io.ByteArrayOutputStream;
import java.nio.charset.StandardCharsets;

@Service
@Path("/promociones")

public class Promociones {


    @Produces(MediaType.APPLICATION_OCTET_STREAM)
    @Path("compileCod")
    @Consumes(MediaType.TEXT_XML)
    @PUT
    public Response compileCodFile(String xml) throws Exception{
        String hola = "holassssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddssssssssss";
        ResponseEntity<ByteArrayResource> result = ResponseEntity.ok().header("Content-Disposition", "attachment; filename=promo.cod")
                .body(new ByteArrayResource(hola.getBytes(StandardCharsets.UTF_8)));

        ByteArrayOutputStream body = this.transform();

        return Response.status(HttpServletResponse.SC_CREATED).entity(body.toByteArray()).header("content-disposition", "attachment; filename=promo.cod").build();
    }

    private ByteArrayOutputStream transform () throws Exception {

        Source xslt = new StreamSource(this.getClass().getClassLoader().getResourceAsStream("article1a.xsl"));
        Source xml  = new StreamSource(this.getClass().getClassLoader().getResourceAsStream("article1.xml"));
        ByteArrayOutputStream out = new ByteArrayOutputStream();
        Result outt  = new StreamResult(out);

        TransformerFactory factory = TransformerFactory.newInstance();
        factory.setAttribute(XMLConstants.ACCESS_EXTERNAL_DTD, "");
        factory.setAttribute(XMLConstants.ACCESS_EXTERNAL_STYLESHEET, "");

        Transformer transformer = factory.newTransformer(xslt);
        transformer.transform(xml, outt);

        return out;

    }

}