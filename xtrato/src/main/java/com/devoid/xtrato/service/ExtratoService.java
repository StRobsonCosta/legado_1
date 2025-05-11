package com.devoid.xtrato.service;

import com.devoid.xtrato.dto.ExtratoDto;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

public class ExtratoService {

    public List<ExtratoDto> buscarExtrato(String conta) {
        // Aqui simulamos a chamada ao mainframe
        return List.of(
                new ExtratoDto(LocalDate.now().minusDays(1), "Pagamento Boleto", new BigDecimal("-250.00")),
                new ExtratoDto(LocalDate.now().minusDays(2), "Depósito", new BigDecimal("1000.00"))
        );
    }
}
