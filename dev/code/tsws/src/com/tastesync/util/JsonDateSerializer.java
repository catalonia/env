package com.tastesync.util;

import org.codehaus.jackson.JsonGenerator;
import org.codehaus.jackson.JsonProcessingException;
import org.codehaus.jackson.map.JsonSerializer;
import org.codehaus.jackson.map.SerializerProvider;

import org.springframework.stereotype.Component;

import java.io.IOException;

import java.text.SimpleDateFormat;

import java.util.Date;


/**
 * Used to serialize Java.util.Date, which is not a common JSON
 * type, so we have to create a custom serialize method;.
 *
 */
@Component
public class JsonDateSerializer extends JsonSerializer<Date> {
    @Override
    public void serialize(Date date, JsonGenerator gen,
        SerializerProvider provider)
        throws IOException {
        gen.writeString(new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(date));
    }
}

