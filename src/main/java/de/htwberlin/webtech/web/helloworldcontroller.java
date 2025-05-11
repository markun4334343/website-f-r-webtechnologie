package de.htwberlin.webtech.web;


import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.servlet.ModelAndView;


@Controller
public class helloworldcontroller {
    @GetMapping("/")
    public String index() {
        return "forward:/index.html";
    }
}






