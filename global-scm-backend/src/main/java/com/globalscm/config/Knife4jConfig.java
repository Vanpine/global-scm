package com.globalscm.config;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Contact;
import io.swagger.v3.oas.models.info.Info;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class Knife4jConfig {

    @Bean
    public OpenAPI openAPI() {
        return new OpenAPI()
            .info(new Info()
                .title("全球供应链大平台 API")
                .description("Global SCM 官网后端接口文档")
                .version("1.0.0")
                .contact(new Contact().name("Global SCM").email("hello@globalscm.com"))
            );
    }
}
