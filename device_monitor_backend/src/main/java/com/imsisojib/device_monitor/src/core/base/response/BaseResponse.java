package com.imsisojib.device_monitor.src.core.base.response;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.imsisojib.device_monitor.src.core.base.model.MetaModel;
import lombok.Data;
import org.springframework.http.HttpStatus;

import java.util.Date;

@Data
@JsonInclude(JsonInclude.Include.NON_NULL)
@JsonIgnoreProperties(ignoreUnknown = true)
public class BaseResponse {
    private Date timestamp;
    private String status;
    private Integer statusCode;
    private String message;
    private Object data;
    private MetaModel meta;

    private BaseResponse(HttpStatus status) {
        this.status = status.name();
        this.timestamp=new Date();
        this.statusCode=status.value();
    }

    private BaseResponse() {
    }

    public static BaseResponse build(HttpStatus status) {
        return new BaseResponse(status);
    }

    public String getStatus() {
        return status;
    }

    public String getMessage() {
        return message;
    }

    public BaseResponse message(String message) {
        this.message = message;
        return this;
    }

    public BaseResponse meta(MetaModel meta) {
        this.meta = meta;
        return this;
    }

    public MetaModel getMeta() {
        return meta;
    }

    public Object getData() {
        return data;
    }

    public BaseResponse body(Object data) {
        this.data = data;
        return this;
    }

}
