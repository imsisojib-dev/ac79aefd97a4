package com.imsisojib.device_monitor.src.core.base.dtos;


import com.google.gson.Gson;
import lombok.Data;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
@Data
public class LoggedInUserDto {

    private String userId;

    private String name;

    private String customerCode;

    private String email;
    private String phone;

    private String token;

    private String loggedInAs;

    private List<String> roles;

    private Long customerId;

    private Long transporterId;

    private String enterpriseCode;

    private List<String> enterpriseCodeList;

    public String toJson(){
        return new Gson().toJson(this);
    }

}
