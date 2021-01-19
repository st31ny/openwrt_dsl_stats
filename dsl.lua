module("luci.statistics.rrdtool.definitions.dsl", package.seeall)

function item()
    return luci.i18n.translate("DSL")
end

function rrdargs(graph, plugin, plugin_instance)
    if "dsl" == plugin then
        function make_graph(title, unit, type, instance, flip)
            flip = flip or false
            local graph = {
                title = "%H: " .. title .. " on %pi",
                vlabel = unit,
                number_format = "%5.1lf %s" .. unit,
                data = {
                    instances = {},
                    options = {},
                },
            }
            graph["data"]["instances"][type] = { instance .. "_down", instance .. "_up" }
            graph["data"]["options"][type .. "_" .. instance .. "_up"] = {
                title   = "TX",
                color   = "27ff19",
                overlay = true,
                noarea = not flip,
            }
            graph["data"]["options"][type .. "_" .. instance .. "_down"] = {
                title   = "RX",
                color   = "1974ff",
                overlay = true,
                noarea = not flip,
                flip = flip,
            }
            return graph
        end

        function make_graph_errors(title, instance)
            local type = "errors"
            local graph = {
                title = "%H: " .. title .. " on %pi",
                vlabel = "errors/s",
                data = {
                    instances = {},
                    options = {},
                },
            }
            graph["data"]["instances"][type] = { instance .. "_near", instance .. "_far" }
            graph["data"]["options"][type .. "_" .. instance .. "_far"] = {
                title   = "Far",
                color = "ff0d9b",
                overlay = true,
                total = true,
            }
            graph["data"]["options"][type .. "_" .. instance .. "_near"] = {
                title   = "Near",
                color   = "ffac01",
                overlay = true,
                flip = true,
                total = true,
            }
            return graph
        end

        local data_rate = make_graph("Data Rate", "Bit/s", "bitrate", "data_rate", true)
        local max_data_rate = make_graph("Max. Attainable Data Rate (ATTNDR)", "Bit/s", "bitrate", "max_data_rate", true)
        local snr = make_graph("Noise Margin (SNR)", "dB", "gauge", "noise_margin")
        local latn = make_graph("Line Attenuation (LATN)", "dB", "gauge", "line_attenuation")
        local satn = make_graph("Signal Attenuation (SATN)", "dB", "gauge", "signal_attenuation")
        local latency = make_graph("Latency", "us", "latency", "latency")
        local actatp = make_graph("Aggregate Transmit Power (ACTATP)", "dBm", "gauge", "actatp")

        local uptime = {
            title = "%H: Uptime of %pi",
            vlabel = "seconds",
            data = {
                instances = { uptime = { "line_uptime" } },
                options = {
                    uptime_line_uptime_value = {
                        title  = "Uptime",
                        noarea = true,
                        color = "ffb319",
                    },
                },
            },
        }

        local err_fecs = make_graph_errors("Forward Error Correction Seconds (FECS)", "errors_fec")
        local err_es = make_graph_errors("Errored Seconds (ES)", "errors_es")
        local err_ses = make_graph_errors("Severely Errored Seconds (SES)", "errors_ses")
        local err_loss = make_graph_errors("Loss of Signal Seconds (LOSS)", "errors_loss")
        local err_uas = make_graph_errors("Unavailable Seconds (UAS)", "errors_uas")
        local err_hec = make_graph_errors("Header Error Code Errors (HEC)", "errors_hec")
        local err_crc = make_graph_errors("Non Pre-emptive CRC errors (CRC_P)", "errors_crc_p")
        local err_crcp = make_graph_errors("Pre-emptive CRC errors (CRCP_P)", "errors_crcp_p")

        return { uptime, data_rate, max_data_rate, latency, latn, satn, snr, actatp,
                 err_fecs, err_es, err_ses, err_loss, err_uas, err_hec, err_crc, err_crcp }
    end
end
