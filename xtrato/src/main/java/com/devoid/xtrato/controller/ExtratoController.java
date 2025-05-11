package com.devoid.xtrato.controller;

import com.devoid.xtrato.dto.ExtratoDto;
import com.devoid.xtrato.service.ExtratoService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import java.util.List;

public class ExtratoController {

    private final ExtratoService service;

    public ExtratoController(ExtratoService service) {
        this.service = service;
    }

    @GetMapping("/{conta}")
    public List<ExtratoDto> buscarExtrato(@PathVariable String conta) {
        return service.buscarExtrato(conta);
    }
}
