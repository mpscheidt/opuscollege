package org.uci.opus.config;

import org.springframework.beans.BeansException;
import org.springframework.beans.factory.config.BeanPostProcessor;
import org.springframework.web.bind.support.WebBindingInitializer;
import org.springframework.web.servlet.mvc.method.annotation.RequestMappingHandlerAdapter;

/**
 * Configure the web binding initializer, which sets the default binding for the date.
 * 
 * See http://vard-lokkur.blogspot.co.at/2010/11/spring-mvc-pitfall-overriding-default.html
 * 
 * @author markus
 *
 */
public class MVCConfigurationPostProcessor implements BeanPostProcessor {

    private WebBindingInitializer webBindingInitializer;

    public Object postProcessAfterInitialization(Object bean, String beanName) throws BeansException {
        if (bean instanceof  RequestMappingHandlerAdapter) {
            ((RequestMappingHandlerAdapter) bean).setWebBindingInitializer(webBindingInitializer);
        }
        return bean;
    }

    public Object postProcessBeforeInitialization(Object bean, String beanName) throws BeansException {
        return bean;
    }   

    public void setWebBindingInitializer(WebBindingInitializer webBindingInitializer) {
        this.webBindingInitializer = webBindingInitializer;
    }
    
}
