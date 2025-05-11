package com.devoid.xtrato.dto;

import java.math.BigDecimal;
import java.time.LocalDate;

public record ExtratoDto(
        LocalDate data,
        String descricao,
        BigDecimal valor
) {}
