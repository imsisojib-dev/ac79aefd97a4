package com.imsisojib.device_monitor.src.core.base.request;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.imsisojib.device_monitor.src.core.base.model.MetaModel;
import lombok.Data;

import java.util.Map;

@Data
@JsonInclude(JsonInclude.Include.NON_NULL)
@JsonIgnoreProperties(ignoreUnknown = true)
public class BaseRequest<T> {

    private MetaModel meta;

    private T body;

    private Map<String , T> mapOfBody;

}
