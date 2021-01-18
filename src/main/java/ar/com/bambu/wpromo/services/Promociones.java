package ar.com.bambu.wpromo.services;


import org.springframework.stereotype.Service;


import javax.servlet.http.HttpServletResponse;
import javax.ws.rs.Consumes;
import javax.ws.rs.PUT;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import javax.xml.XMLConstants;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import javax.xml.transform.Result;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import java.io.*;
import java.net.URL;

import java.util.Date;

@Service
@Path("/promociones")

public class Promociones {


    @Produces(MediaType.APPLICATION_OCTET_STREAM)
    @Path("compileCod")
    @Consumes(MediaType.TEXT_XML)
    @PUT
    public Response compileCodFile(String xml) throws Exception{


        ByteArrayOutputStream body = this.transform(this.createXml(xml));
        return Response.status(HttpServletResponse.SC_CREATED).entity(body.toByteArray()).header("content-disposition", "attachment; filename=promo.pro").build();
    }

    private File createXml(String xml) throws Exception {
        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
        DocumentBuilder builder = factory.newDocumentBuilder();


        Date now = new Date();
        File file = new File(now.getTime()+"prog.xml");

        file.delete();
        file.createNewFile();
        FileWriter writer = new FileWriter(file);
        writer.write(xml);
        writer.close();
        builder.parse(file);
        return  file;

    }

    private ByteArrayOutputStream transform (File xmlprog) throws Exception {
        URL resource = this.getClass().getClassLoader().getResource("plantillas/common/prog.xsl");

        Source xslt = new StreamSource(resource.toExternalForm());

        Source xml  = new StreamSource(this.getClass().getClassLoader().getResourceAsStream("plantillas/common/tree.xml"));
        ByteArrayOutputStream out = new ByteArrayOutputStream();
        Result outt  = new StreamResult(out);

        TransformerFactory factory = TransformerFactory.newInstance();
        factory.setAttribute(XMLConstants.ACCESS_EXTERNAL_DTD, "");
        factory.setAttribute(XMLConstants.ACCESS_EXTERNAL_STYLESHEET, "all");

        Transformer transformer = factory.newTransformer(xslt);
        transformer.setParameter("pathProgXml", xmlprog.getAbsolutePath());

        transformer.transform(xml, outt);

        System.out.println(new String(out.toByteArray()));

        return out;

    }

}
