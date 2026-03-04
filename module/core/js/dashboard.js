function topbar() {
  $.ajax({
    type: "POST",
    url: "connect.php",
    headers: {
      Authorization: "Bearer " + md5(localStorage.getItem("sessionObject")),
    },
    data: {
      package: overal({
        origin: "module/core/php/dashboarddb.php",
        function: "topbar",
        attr: "",
      }),
    },
    success: function (response) {
      var res = pars(JSON.parse(response));
      var divs = "";
      for (var i = 0; i < res["arr"].length; i++) {
        var rawEspaco = parseInt(res["arr"][i]["espaco"], 10);
        var colLg = 12;

        if (!isNaN(rawEspaco) && rawEspaco > 0) {
          if (rawEspaco <= 2) {
            colLg = rawEspaco * 6;
          } else {
            colLg = Math.floor(12 / rawEspaco);
          }

          if (colLg < 3) {
            colLg = 3;
          }
          if (colLg > 12) {
            colLg = 12;
          }
        }

        if (
          res["arr"][i]["opcao"] == 1 ||
          res["arr"][i]["opcao"] == 3 ||
          res["arr"][i]["opcao"] == 4 ||
          res["arr"][i]["opcao"] == 5 ||
          res["arr"][i]["opcao"] == 6
        ) {
          colLg = 12;
        }

        divs +=
          "<div class='col-lg-" +
          colLg +
          " col-md-12 col-12' id='masterdiv" +
          res["arr"][i]["opcao"] +
          "'>";
        divs += "<div class='panel panel-inverse'>";
        divs +=
          "<div class='panel-heading dashboard-main-panel-heading' id='blackbar_" +
          res["arr"][i]["opcao"] +
          "'>";
        divs +=
          "<div class='panel-heading-btn' id='content" +
          res["arr"][i]["opcao"] +
          "btn'>";
        divs += "</div>";
        divs += "<h4 class='panel-title'>" + res["arr"][i]["titulo"] + "</h4>";
        divs += "</div>";
        if (res["arr"][i]["opcao"] == 8) {
          divs += "<div class='panel-body panel-with-tabs'>";
        } else {
          divs += "<div class='panel-body'>";
        }
        divs += "<div id='content" + res["arr"][i]["opcao"] + "'></div>";
        divs += "</div>";
        divs +=
          "<a id='btncontent" +
          res["arr"][i]["opcao"] +
          "' class='btn btn-xs btn-icon btn-circle btn-default' data-click='panel-refresh' style='visibility:hidden;'><i class='fa fa-sync'></i></a>";
        divs += "</div>";
        divs += "</div>";
      }
      $("#dashrows").html(divs);
      setupDashboardPanelHeaderToggle();
      $("#dashrows .panel .panel-body").hide();

      for (var i = 0; i < res["arr"].length; i++) {
        reworkbar(res["arr"][i]["opcao"]);
      }
    },
    error: function (jqXHR, textStatus) {
      moderr("Request failed: " + textStatus);
    },
  });
}

function setupDashboardPanelHeaderToggle() {
  $(document)
    .off("click.dashboardPanelHeading", ".dashboard-main-panel-heading")
    .on(
      "click.dashboardPanelHeading",
      ".dashboard-main-panel-heading",
      function (e) {
        if (
          $(e.target).closest(
            ".panel-heading-btn, a, button, input, select, textarea, label, [data-click]",
          ).length
        ) {
          return;
        }

        var $panel = $(this).closest(".panel");
        var $panelBody = $panel.children(".panel-body").first();
        if (!$panelBody.length) {
          return;
        }

        var isVisible = $panelBody.is(":visible");
        $panelBody.stop(true, true).slideToggle(150);

        var $icon = $panel
          .find(".panel-heading-btn [data-click='panel-collapse'] i")
          .first();
        if ($icon.length) {
          $icon.toggleClass("fa-minus", !isVisible);
          $icon.toggleClass("fa-plus", isVisible);
        }
      },
    );
}

var DASHBOARD_BREAKPOINTS = {
  smallMobileMax: 400,
  mobileMax: 768,
  compactMax: 1138,
  smallTabletMax: 900,
};

function getDashboardDefaultPanelButtons() {
  return (
    "<a href='javascript:;' class='btn btn-xs btn-icon btn-circle btn-default' data-click='panel-collapse'>" +
    "<i class='fa fa-plus'></i>" +
    "</a>"
  );
}

function reworkbar(esc, opc = 0) {
  $.ajax({
    type: "POST",
    url: "connect.php",
    headers: {
      Authorization: "Bearer " + md5(localStorage.getItem("sessionObject")),
    },
    data: {
      package: overal({
        origin: "module/core/php/dashboarddb.php",
        function: "reworkbar",
        attr: JSON.stringify({ esc: esc, opc: opc }),
      }),
    },
    success: function (response) {
      var obj = pars(JSON.parse(response));
      $("#content" + esc).html(obj["msg"]);
      var panelButtons = (obj["btn"] || "").toString().trim();
      if (panelButtons === "") {
        panelButtons = getDashboardDefaultPanelButtons();
      }
      $("#content" + esc + "btn").html(panelButtons);
      if (esc == 1) {
        renderDashboardStats(obj.array || {});
      } else if (esc == 2) {
        renderDashboardCsvTable(obj.array);
      } else if (esc == 3) {
        renderDashboardVendasTable(obj.array);
      } else if (esc == 4) {
        renderDashboardProdutosTable(obj.array);
      } else if (esc == 5) {
        renderDashboardCategoriasTable(obj.array);
      } else if (esc == 6) {
        renderDashboardCidadesTable(obj.array);
      }
    },
    error: function (jqXHR, textStatus) {
      moderr("Request failed: " + textStatus);
    },
  });
}

var dashboardMonthlyChart = null;
var dashboardCategoryChart = null;
var dashboardChannelChart = null;
var dashboardStatsCategoryData = [];
var dashboardStatsChannelData = [];

var dashboardOrangeYellowPalette = ["#F28E2B", "#1F3A5F", "#000000", "#6B7280"];

function parseDashboardResponse(response) {
  return pars(typeof response === "string" ? JSON.parse(response) : response);
}

function getDashboardBulkTableInstance(tableId) {
  if (!$.fn.DataTable || !$.fn.DataTable.isDataTable("#" + tableId)) {
    return null;
  }
  return $("#" + tableId).DataTable();
}

function getDashboardBulkRowCheckboxNodes(
  tableId,
  rowSelectorClass,
  onlyAppliedSearch,
) {
  var table = getDashboardBulkTableInstance(tableId);
  if (table) {
    var rowsApi = onlyAppliedSearch
      ? table.rows({ search: "applied" })
      : table.rows();
    return rowsApi
      .nodes()
      .to$()
      .find("." + rowSelectorClass);
  }

  return $("#" + tableId + " tbody ." + rowSelectorClass);
}

function getDashboardBulkSelectedIds(tableId, rowSelectorClass) {
  var ids = [];
  getDashboardBulkRowCheckboxNodes(tableId, rowSelectorClass, false)
    .filter(":checked")
    .each(function () {
      var rowId = parseInt($(this).attr("data-id"), 10);
      if (!isNaN(rowId) && rowId > 0) {
        ids.push(rowId);
      }
    });

  return ids;
}

function updateDashboardBulkDeleteButtonState(
  tableId,
  rowSelectorClass,
  deleteBtnId,
  selectAllId,
) {
  var selectedIds = getDashboardBulkSelectedIds(tableId, rowSelectorClass);
  var hasSelection = selectedIds.length > 0;
  var $deleteBtn = $("#" + deleteBtnId);
  if ($deleteBtn.length) {
    $deleteBtn.prop("disabled", !hasSelection);
  }

  syncDashboardCardSelectedState(tableId, rowSelectorClass);

  var $allRows = getDashboardBulkRowCheckboxNodes(
    tableId,
    rowSelectorClass,
    false,
  );
  var totalCount = $allRows.length;
  var checkedCount = $allRows.filter(":checked").length;
  var $selectAll = $("#" + selectAllId);

  updateDashboardBulkSelectAllLabel(tableId, rowSelectorClass, selectAllId);

  if ($selectAll.length) {
    if (totalCount < 1) {
      if ($selectAll.prop("checked") !== false) {
        $selectAll.prop("checked", false);
      }
      if ($selectAll.prop("indeterminate") !== false) {
        $selectAll.prop("indeterminate", false);
      }
      return;
    }

    var nextChecked = checkedCount === totalCount;
    var nextIndeterminate = checkedCount > 0 && checkedCount < totalCount;

    if ($selectAll.prop("checked") !== nextChecked) {
      $selectAll.prop("checked", nextChecked);
    }
    if ($selectAll.prop("indeterminate") !== nextIndeterminate) {
      $selectAll.prop("indeterminate", nextIndeterminate);
    }
  }
}

function isDashboardCardViewport() {
  return (
    (window.innerWidth || document.documentElement.clientWidth) <=
    DASHBOARD_BREAKPOINTS.compactMax
  );
}

function syncDashboardCardSelectedState(tableId, rowSelectorClass) {
  if (!isDashboardCardViewport()) {
    $("#" + tableId + " tbody tr").removeClass("dashboard-card-selected");
    return;
  }

  $("#" + tableId + " tbody tr").each(function () {
    var $row = $(this);
    var $checkbox = $row.find("." + rowSelectorClass).first();
    if (!$checkbox.length) return;
    $row.toggleClass("dashboard-card-selected", $checkbox.is(":checked"));
  });
}

function updateDashboardBulkSelectAllLabel(
  tableId,
  rowSelectorClass,
  selectAllId,
) {
  var selectedCount = getDashboardBulkRowCheckboxNodes(
    tableId,
    rowSelectorClass,
    false,
  ).filter(":checked").length;

  var $desktopText = $("#" + selectAllId)
    .closest("label")
    .find(".dashboard-bulk-select-text")
    .first();
  if ($desktopText.length) {
    var desktopBase =
      $desktopText.attr("data-base-text") ||
      $.trim($desktopText.text()) ||
      "Sel. Todos";
    $desktopText.attr("data-base-text", desktopBase);
    $desktopText
      .empty()
      .append(
        $("<span>", {
          class: "dashboard-bulk-select-main",
          text: desktopBase,
        }),
      )
      .append(
        $("<span>", {
          class: "dashboard-bulk-select-count",
          text: "(" + selectedCount + ")",
        }),
      );
  }
}

function bindDashboardCardTapSelection(
  tableId,
  rowSelectorClass,
  selectAllId,
  deleteBtnId,
  eventNamespace,
) {
  var namespace = eventNamespace || "dashboardCardTap";
  var selector = "#" + tableId + " tbody tr";

  $(document)
    .off("click." + namespace, selector)
    .on("click." + namespace, selector, function (event) {
      var $target = $(event.target);
      if (
        $target.closest(
          "a, button, input, select, textarea, label, .btn, .dropdown-menu, .dropdown-item",
        ).length
      ) {
        return;
      }

      var $row = $(this);
      var $checkbox = $row.find("." + rowSelectorClass).first();
      if (!$checkbox.length || $checkbox.is(":disabled")) {
        return;
      }

      $checkbox.prop("checked", !$checkbox.is(":checked")).trigger("change");
      updateDashboardBulkDeleteButtonState(
        tableId,
        rowSelectorClass,
        deleteBtnId,
        selectAllId,
      );
    });
}

function bindDashboardBulkSelectionHandlers(
  tableId,
  rowSelectorClass,
  selectAllId,
  deleteBtnId,
) {
  bindDashboardCardTapSelection(
    tableId,
    rowSelectorClass,
    selectAllId,
    deleteBtnId,
    "dashboardCardTap_" + tableId,
  );

  $(document)
    .off("change.dashboardBulkSelectAll", "#" + selectAllId)
    .on("change.dashboardBulkSelectAll", "#" + selectAllId, function () {
      var checked = $(this).is(":checked");
      $(this).prop("indeterminate", false);
      getDashboardBulkRowCheckboxNodes(tableId, rowSelectorClass, false).prop(
        "checked",
        checked,
      );
      $("#" + tableId + " tbody ." + rowSelectorClass).prop("checked", checked);
      updateDashboardBulkDeleteButtonState(
        tableId,
        rowSelectorClass,
        deleteBtnId,
        selectAllId,
      );
    });

  $(document)
    .off(
      "change.dashboardBulkRow",
      "#" + tableId + " tbody ." + rowSelectorClass,
    )
    .on(
      "change.dashboardBulkRow",
      "#" + tableId + " tbody ." + rowSelectorClass,
      function () {
        updateDashboardBulkDeleteButtonState(
          tableId,
          rowSelectorClass,
          deleteBtnId,
          selectAllId,
        );
      },
    );

  $("#" + tableId)
    .off("draw.dt.dashboardBulk")
    .on("draw.dt.dashboardBulk", function () {
      updateDashboardBulkDeleteButtonState(
        tableId,
        rowSelectorClass,
        deleteBtnId,
        selectAllId,
      );
    });

  updateDashboardBulkDeleteButtonState(
    tableId,
    rowSelectorClass,
    deleteBtnId,
    selectAllId,
  );
}

async function deleteDashboardSelectedRows(config) {
  var ids = getDashboardBulkSelectedIds(
    config.tableId,
    config.rowSelectorClass,
  );
  if (ids.length < 1) {
    toaster("Selecione pelo menos um registo para eliminar.", "warning");
    return;
  }

  showDashboardLoadingAlert(
    "A eliminar registos",
    "Aguarde, estamos a processar a eliminação...",
  );

  try {
    var response = await $.ajax({
      type: "POST",
      url: "connect.php",
      dataType: "text",
      headers: {
        Authorization: "Bearer " + md5(localStorage.getItem("sessionObject")),
      },
      data: {
        package: overal({
          origin: "module/core/php/dashboarddb.php",
          function: config.backendFunction,
          attr: JSON.stringify({ ids: ids }),
        }),
      },
    });
    var obj = parseDashboardResponse(response);
    if (obj.val == 1) {
      toaster(obj.msg || "Operação realizada com sucesso.", "success");
      reloadDashboardPage();
    } else {
      toaster(obj.msg || "Erro ao eliminar registos.", "error");
    }
  } catch (error) {
    toaster(
      "Erro ao eliminar registos: " +
        (error.statusText || error.message || error),
      "error",
    );
  } finally {
    closeDashboardLoadingAlert();
  }
}

function normalizeDashboardFilterText(value) {
  return (value || "")
    .toString()
    .trim()
    .toLowerCase()
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "");
}

function formatDashboardDateInputFromDate(dateObj) {
  if (!(dateObj instanceof Date) || isNaN(dateObj.getTime())) {
    return "";
  }

  var year = dateObj.getFullYear();
  var month = String(dateObj.getMonth() + 1).padStart(2, "0");
  var day = String(dateObj.getDate()).padStart(2, "0");
  return year + "-" + month + "-" + day;
}

function getDashboardMonthDateRangeFromTimestamp(timestamp) {
  var tsNumber = parseInt(timestamp, 10);
  if (isNaN(tsNumber)) {
    return null;
  }

  var referenceDate = new Date(tsNumber);
  if (isNaN(referenceDate.getTime())) {
    return null;
  }

  var startDateObj = new Date(
    referenceDate.getFullYear(),
    referenceDate.getMonth(),
    1,
  );
  var endDateObj = new Date(
    referenceDate.getFullYear(),
    referenceDate.getMonth() + 1,
    0,
  );

  return {
    start: formatDashboardDateInputFromDate(startDateObj),
    end: formatDashboardDateInputFromDate(endDateObj),
  };
}

function setDashboardSelectByLabel(selectSelector, label) {
  var $select = $(selectSelector);
  if (!$select.length) {
    return false;
  }

  var normalizedTarget = normalizeDashboardFilterText(label);
  if (normalizedTarget === "") {
    $select.val("");
    return true;
  }

  var selectedValue = "";
  $select.find("option").each(function () {
    var optionValue = $(this).val();
    var optionText = $(this).text();
    var optionValueNormalized = normalizeDashboardFilterText(optionValue);
    var optionTextNormalized = normalizeDashboardFilterText(optionText);

    if (
      optionValueNormalized === normalizedTarget ||
      optionTextNormalized === normalizedTarget
    ) {
      selectedValue = optionValue;
      return false;
    }
  });

  if (selectedValue === "") {
    return false;
  }

  $select.val(selectedValue);
  return true;
}

function showDashboardLoadingAlert(title, text) {
  var spinner = document.createElement("div");
  spinner.className = "swal-loading-content";
  spinner.innerHTML =
    '<div class="swal-loading-spinner"><span class="swal-loading-dot"></span></div>' +
    '<div class="swal-loading-progress"></div>';

  var opts = {
    title: title,
    text: text,
    content: spinner,
    className: "swal-modal--loading",
    buttons: false,
    closeOnClickOutside: false,
    closeOnEsc: false,
  };

  if (typeof oldSwal === "function") {
    new oldSwal(opts);
    return;
  }

  if (typeof swal === "function") {
    swal(opts);
  }
}

function closeDashboardLoadingAlert() {
  if (typeof oldSwal === "function" && typeof oldSwal.close === "function") {
    oldSwal.close();
  }

  if (typeof swal === "function" && typeof swal.close === "function") {
    swal.close();
  }

  $(".swal-overlay").remove();
  $(".swal-modal").remove();
  $("body").removeClass("stop-scrolling");
}

function closeDashboardModalAndRefresh(modalSelector, refreshCallback) {
  var $modal = $(modalSelector);
  var refreshed = false;

  var finalize = function () {
    if (refreshed) {
      return;
    }
    refreshed = true;
    $(".modal-backdrop").remove();
    $("body").removeClass("modal-open").css("padding-right", "");
    if (typeof refreshCallback === "function") {
      refreshCallback();
    }
  };

  if ($modal.length) {
    $modal.one("hidden.bs.modal", finalize);
    $modal.modal("hide");
    setTimeout(finalize, 450);
    return;
  }

  finalize();
}

function reloadDashboardPage(delayMs) {
  var delay = parseInt(delayMs, 10);
  if (isNaN(delay) || delay < 0) {
    delay = 250;
  }

  setTimeout(function () {
    window.location.reload();
  }, delay);
}

function getDashboardChartColors(labels) {
  var colors = [];

  for (var i = 0; i < labels.length; i++) {
    colors.push(
      dashboardOrangeYellowPalette[i % dashboardOrangeYellowPalette.length],
    );
  }

  return colors;
}

function applyDashboardChartFilter(filterType, payload) {
  var didApply = false;

  if (filterType === "categoria" || filterType === "canal") {
    var selectSelector =
      filterType === "categoria"
        ? "#dashboardVendasCategoria"
        : "#dashboardVendasCanal";

    if (!$(selectSelector).length) {
      return;
    }

    var targetLabel = (payload || "").toString();
    var currentValue = $(selectSelector).val() || "";
    var currentText =
      $(selectSelector + " option:selected").text() || currentValue;

    var isSameSelection =
      normalizeDashboardFilterText(currentText) ===
        normalizeDashboardFilterText(targetLabel) ||
      normalizeDashboardFilterText(currentValue) ===
        normalizeDashboardFilterText(targetLabel);

    if (isSameSelection) {
      $(selectSelector).val("");
      didApply = true;
    } else {
      didApply = setDashboardSelectByLabel(selectSelector, targetLabel);
    }
  } else if (filterType === "month") {
    if (
      !$("#dashboardVendasStartDate").length ||
      !$("#dashboardVendasEndDate").length
    ) {
      return;
    }

    var monthRange = getDashboardMonthDateRangeFromTimestamp(payload);
    if (!monthRange) {
      return;
    }

    var currentStart = $("#dashboardVendasStartDate").val() || "";
    var currentEnd = $("#dashboardVendasEndDate").val() || "";

    if (currentStart === monthRange.start && currentEnd === monthRange.end) {
      $("#dashboardVendasStartDate").val("");
      $("#dashboardVendasEndDate").val("");
    } else {
      $("#dashboardVendasStartDate").val(monthRange.start);
      $("#dashboardVendasEndDate").val(monthRange.end);
    }
    didApply = true;
  } else if (filterType === "range") {
    if (
      !payload ||
      !$("#dashboardVendasStartDate").length ||
      !$("#dashboardVendasEndDate").length
    ) {
      return;
    }

    var minNumber = parseInt(payload.min, 10);
    var maxNumber = parseInt(payload.max, 10);
    if (isNaN(minNumber) || isNaN(maxNumber)) {
      return;
    }

    var startRef = new Date(Math.min(minNumber, maxNumber));
    var endRef = new Date(Math.max(minNumber, maxNumber));
    var startDate = new Date(startRef.getFullYear(), startRef.getMonth(), 1);
    var endDate = new Date(endRef.getFullYear(), endRef.getMonth() + 1, 0);

    var nextStart = formatDashboardDateInputFromDate(startDate);
    var nextEnd = formatDashboardDateInputFromDate(endDate);
    var currentStartRange = $("#dashboardVendasStartDate").val() || "";
    var currentEndRange = $("#dashboardVendasEndDate").val() || "";

    if (currentStartRange === nextStart && currentEndRange === nextEnd) {
      $("#dashboardVendasStartDate").val("");
      $("#dashboardVendasEndDate").val("");
      didApply = true;
    } else {
      $("#dashboardVendasStartDate").val(nextStart);
      $("#dashboardVendasEndDate").val(nextEnd);
      didApply = true;
    }
  }

  if (didApply) {
    applyDashboardVendasFilters();
  }
}

function formatDashboardCurrency(value) {
  var number = parseFloat(value);
  if (isNaN(number)) {
    number = 0;
  }
  return (
    number.toLocaleString("pt-PT", {
      minimumFractionDigits: 2,
      maximumFractionDigits: 2,
    }) + " €"
  );
}

function parseDashboardLocaleNumber(value) {
  var raw = (value || "").toString().trim();
  if (raw === "") {
    return NaN;
  }

  var normalized = raw.replace(/\s/g, "").replace(/€/g, "");
  if (normalized.indexOf(",") > -1) {
    normalized = normalized.replace(/\./g, "").replace(",", ".");
  }

  return parseFloat(normalized);
}

function formatDashboardInt(value) {
  var number = parseInt(value, 10);
  if (isNaN(number)) {
    number = 0;
  }
  return number.toLocaleString("pt-PT");
}

function renderDashboardStats(stats) {
  if (!stats || typeof stats !== "object") {
    return;
  }

  var revenue = stats.revenue || {};
  var monthly = Array.isArray(stats.monthly) ? stats.monthly : [];
  var categories = Array.isArray(stats.categories) ? stats.categories : [];
  var channels = Array.isArray(stats.channels) ? stats.channels : [];
  var cities = Array.isArray(stats.cities) ? stats.cities : [];
  var topProducts = Array.isArray(stats.topProducts) ? stats.topProducts : [];

  dashboardStatsCategoryData = categories;
  dashboardStatsChannelData = channels;

  $("#dashboardStatsTotalRevenue").text(
    formatDashboardCurrency(revenue.totalRevenue),
  );
  $("#dashboardStatsAverageTicket").text(
    formatDashboardCurrency(revenue.averageTicket),
  );
  $("#dashboardStatsTotalSales").text(formatDashboardInt(revenue.totalSales));
  $("#dashboardStatsTotalQuantity").text(
    formatDashboardInt(revenue.totalQuantity),
  );

  renderDashboardMonthlyChart(monthly);
  renderDashboardCategoryChart(categories);
  renderDashboardChannelChart(channels);
  renderDashboardTopProducts(topProducts);
  renderDashboardCities(cities);
}

function getDashboardChartHeight() {
  var viewportWidth = window.innerWidth || document.documentElement.clientWidth;
  if (viewportWidth <= DASHBOARD_BREAKPOINTS.compactMax) {
    return 250;
  }
  return 300;
}

function renderDashboardMonthlyChart(monthly) {
  if (
    !document.querySelector("#dashboardMonthlyChart") ||
    typeof ApexCharts === "undefined"
  ) {
    return;
  }

  var monthNames = [
    "Janeiro",
    "Fevereiro",
    "Março",
    "Abril",
    "Maio",
    "Junho",
    "Julho",
    "Agosto",
    "Setembro",
    "Outubro",
    "Novembro",
    "Dezembro",
  ];
  var monthRevenue = {};

  for (var i = 0; i < (monthly || []).length; i++) {
    var monthLabel = (monthly[i] && monthly[i].label ? monthly[i].label : "")
      .toString()
      .trim();
    var revenue = parseFloat(monthly[i].revenue) || 0;
    var labelParts = monthLabel.split("-");
    if (labelParts.length >= 2) {
      var parsedMonth = parseInt(labelParts[1], 10);
      if (parsedMonth >= 1 && parsedMonth <= 12) {
        if (typeof monthRevenue[parsedMonth] === "undefined") {
          monthRevenue[parsedMonth] = 0;
        }
        monthRevenue[parsedMonth] += revenue;
      }
    }
  }

  var monthNumbers = Object.keys(monthRevenue)
    .map(function (key) {
      return parseInt(key, 10);
    })
    .filter(function (monthNumber) {
      return !isNaN(monthNumber) && monthNumber >= 1 && monthNumber <= 12;
    })
    .sort(function (a, b) {
      return a - b;
    });

  var monthLabels = monthNumbers.map(function (monthNumber) {
    return monthNames[monthNumber - 1] || "";
  });

  var totalYearRevenue = 0;
  var maxMonthRevenue = 0;

  var columnData = [];
  var lineData = [];

  for (var keyIdx = 0; keyIdx < monthNumbers.length; keyIdx++) {
    var monthNumber = monthNumbers[keyIdx];
    var monthValue = monthRevenue[monthNumber] || 0;
    totalYearRevenue += monthValue;
    if (monthValue > maxMonthRevenue) {
      maxMonthRevenue = monthValue;
    }

    columnData.push(monthValue);
    lineData.push(monthValue);
  }

  $("#dashboardStatsTotalRevenue").text(
    formatDashboardCurrency(totalYearRevenue),
  );

  if (dashboardMonthlyChart) {
    dashboardMonthlyChart.destroy();
  }

  var viewportWidth = window.innerWidth || document.documentElement.clientWidth;
  var isSmallMobile = viewportWidth <= DASHBOARD_BREAKPOINTS.smallMobileMax;
  var isMobile = viewportWidth <= DASHBOARD_BREAKPOINTS.mobileMax;
  var isSmallTablet =
    viewportWidth > DASHBOARD_BREAKPOINTS.mobileMax &&
    viewportWidth <= DASHBOARD_BREAKPOINTS.smallTabletMax;
  var isTablet =
    viewportWidth > DASHBOARD_BREAKPOINTS.smallTabletMax &&
    viewportWidth <= DASHBOARD_BREAKPOINTS.compactMax;

  // Chart height per breakpoint
  var chartHeight;
  if (isSmallMobile) {
    chartHeight = 260;
  } else if (isSmallTablet) {
    chartHeight = 270;
  } else if (isMobile) {
    chartHeight = 280;
  } else if (isTablet) {
    chartHeight = 280;
  } else {
    chartHeight = 300;
  }

  // Y-axis max: custom scale for mobile, auto for desktop
  var yAxisMax;
  if (isMobile) {
    if (maxMonthRevenue > 0) {
      var step = 5000;
      if (maxMonthRevenue > 50000) step = 10000;
      if (maxMonthRevenue > 100000) step = 25000;
      if (maxMonthRevenue > 500000) step = 100000;
      yAxisMax = Math.ceil((maxMonthRevenue * 1.2) / step) * step;
    } else {
      yAxisMax = 1000;
    }
  } else {
    yAxisMax = maxMonthRevenue > 0 ? Math.ceil(maxMonthRevenue * 1.2) : 1000;
  }

  // DataLabels config per breakpoint
  var dlFontSize, dlOffsetY, dlUseCompact;
  if (isSmallMobile) {
    dlFontSize = "10px";
    dlOffsetY = -18;
    dlUseCompact = true;
  } else if (isSmallTablet) {
    dlFontSize = "11px";
    dlOffsetY = -20;
    dlUseCompact = true;
  } else if (isMobile) {
    dlFontSize = "11px";
    dlOffsetY = -20;
    dlUseCompact = true;
  } else if (isTablet) {
    dlFontSize = "12px";
    dlOffsetY = -22;
    dlUseCompact = false;
  } else {
    dlFontSize = "16px";
    dlOffsetY = -27;
    dlUseCompact = false;
  }

  var options = {
    chart: {
      type: "line",
      height: chartHeight,
      zoom: {
        enabled: true,
        type: "x",
        autoScaleYaxis: true,
      },
      selection: {
        enabled: true,
        type: "x",
      },
      toolbar: {
        show: !isMobile,
        autoSelected: "zoom",
      },
    },
    series: [
      {
        name: "Receita (Colunas)",
        type: "column",
        data: columnData,
      },
      {
        name: "Receita (Linha)",
        type: "line",
        data: lineData,
      },
    ],
    colors: ["#FF8800", "#1a1a1a"],
    dataLabels: {
      enabled: true,
      enabledOnSeries: isMobile ? [0] : [1],
      offsetY: dlOffsetY,
      formatter: function (val) {
        if (dlUseCompact) {
          var numericVal = parseFloat(val) || 0;
          if (Math.abs(numericVal) >= 1000) {
            var compact = (numericVal / 1000).toFixed(1).replace(/\.0$/, "");
            return compact + "k";
          }
          return Math.round(numericVal).toString();
        }
        return formatDashboardInt(val);
      },
      style: {
        fontSize: dlFontSize,
        fontWeight: "bold",
        colors: ["#111111"],
      },
      background: {
        enabled: !isMobile,
        foreColor: "#111111",
        borderRadius: 4,
        padding: isMobile ? 3 : 6,
        opacity: 1,
        borderWidth: isMobile ? 1 : 2,
        borderColor: "#FF8800",
      },
      dropShadow: {
        enabled: false,
      },
    },
    markers: {
      size: [0, isSmallMobile ? 3 : isMobile ? 4 : 5],
      colors: ["#FF8800", "#1a1a1a"],
      strokeColors: "#fff",
      strokeWidth: 2,
      hover: {
        size: isMobile ? 5 : 7,
      },
    },
    xaxis: {
      type: "category",
      categories: monthLabels,
      labels: {
        style: {
          fontSize: isSmallMobile ? "9px" : isMobile ? "10px" : "12px",
        },
        formatter: function (value) {
          if (!value) {
            return "";
          }
          if (isMobile) {
            return value.substring(0, 3);
          }
          return value;
        },
      },
    },
    grid: {
      padding: {
        top: isSmallMobile ? 20 : isMobile ? 22 : 8,
        left: 20,
        right: 20,
      },
    },
    stroke: {
      curve: "smooth",
      width: [0, isSmallMobile ? 2 : isMobile ? 3 : 4],
    },
    plotOptions: {
      bar: {
        columnWidth: isSmallMobile ? "35%" : isMobile ? "38%" : "45%",
        borderRadius: 4,
        dataLabels: {
          position: "top",
        },
      },
    },
    yaxis: {
      max: yAxisMax,
      forceNiceScale: !isMobile,
      tickAmount: isSmallMobile ? 4 : isMobile ? 5 : undefined,
      labels: {
        style: {
          fontSize: isSmallMobile ? "9px" : isMobile ? "10px" : "12px",
        },
        formatter: function (val) {
          return formatDashboardCurrency(val);
        },
      },
    },
    legend: {
      position: "bottom",
      fontSize: isSmallMobile ? "10px" : isMobile ? "11px" : "12px",
      itemMargin: {
        horizontal: isSmallMobile ? 4 : 8,
        vertical: 4,
      },
    },
    tooltip: {
      y: {
        formatter: function (val) {
          return formatDashboardCurrency(val);
        },
      },
    },
    noData: {
      text: "Sem dados",
    },
  };

  dashboardMonthlyChart = new ApexCharts(
    document.querySelector("#dashboardMonthlyChart"),
    options,
  );
  dashboardMonthlyChart.render();
}

function renderDashboardCategoryChart(categories) {
  if (
    !document.querySelector("#dashboardCategoryChart") ||
    typeof ApexCharts === "undefined"
  ) {
    return;
  }

  var labels = [];
  var values = [];
  for (var i = 0; i < categories.length; i++) {
    labels.push(categories[i].label || "Desconhecido");
    values.push(parseFloat(categories[i].revenue) || 0);
  }

  var barColors = getDashboardChartColors(labels);

  if (dashboardCategoryChart) {
    dashboardCategoryChart.destroy();
  }

  var chartHeight = getDashboardChartHeight();

  var options = {
    chart: {
      type: "bar",
      height: chartHeight,
      toolbar: {
        show: false,
      },
      events: {
        dataPointSelection: function (event, chartContext, config) {
          var dataPointIndex =
            config && typeof config.dataPointIndex === "number"
              ? config.dataPointIndex
              : -1;
          if (dataPointIndex < 0 || dataPointIndex >= labels.length) {
            return;
          }

          var apexLabels =
            config &&
            config.w &&
            config.w.globals &&
            Array.isArray(config.w.globals.labels)
              ? config.w.globals.labels
              : labels;
          var selectedLabel =
            dataPointIndex < apexLabels.length
              ? apexLabels[dataPointIndex]
              : "";

          applyDashboardChartFilter("categoria", selectedLabel);
        },
      },
    },
    series: [
      {
        name: "Receita",
        data: values,
      },
    ],
    xaxis: {
      categories: labels,
    },
    colors: barColors,
    plotOptions: {
      bar: {
        horizontal: false,
        distributed: true,
      },
    },
    yaxis: {
      labels: {
        formatter: function (val) {
          return formatDashboardCurrency(val);
        },
      },
    },
    tooltip: {
      y: {
        formatter: function (val) {
          return formatDashboardCurrency(val);
        },
      },
    },
    noData: {
      text: "Sem dados",
    },
  };

  dashboardCategoryChart = new ApexCharts(
    document.querySelector("#dashboardCategoryChart"),
    options,
  );
  dashboardCategoryChart.render();
}

function renderDashboardChannelChart(channels) {
  if (
    !document.querySelector("#dashboardChannelChart") ||
    typeof ApexCharts === "undefined"
  ) {
    return;
  }

  var labels = [];
  var values = [];
  for (var i = 0; i < channels.length; i++) {
    labels.push(channels[i].label || "Desconhecido");
    values.push(parseFloat(channels[i].revenue) || 0);
  }

  var donutColors = getDashboardChartColors(labels);

  if (dashboardChannelChart) {
    dashboardChannelChart.destroy();
  }

  var chartHeight = getDashboardChartHeight();
  var viewportWidth = window.innerWidth || document.documentElement.clientWidth;
  var isTabletOrMobile = viewportWidth <= DASHBOARD_BREAKPOINTS.compactMax;
  var isMobile = viewportWidth <= DASHBOARD_BREAKPOINTS.mobileMax;

  var options = {
    chart: {
      type: "donut",
      height: chartHeight,
      events: {
        dataPointSelection: function (event, chartContext, config) {
          var dataPointIndex =
            config && typeof config.dataPointIndex === "number"
              ? config.dataPointIndex
              : -1;
          if (dataPointIndex < 0 || dataPointIndex >= labels.length) {
            return;
          }

          var apexLabels =
            config &&
            config.w &&
            config.w.globals &&
            Array.isArray(config.w.globals.labels)
              ? config.w.globals.labels
              : labels;
          var selectedLabel =
            dataPointIndex < apexLabels.length
              ? apexLabels[dataPointIndex]
              : "";

          applyDashboardChartFilter("canal", selectedLabel);
        },
      },
    },
    labels: labels,
    series: values,
    colors: donutColors,
    dataLabels: {
      enabled: !isMobile,
      minAngleToShowLabel: 12,
    },
    legend: {
      position: isTabletOrMobile ? "bottom" : "right",
      horizontalAlign: isTabletOrMobile ? "center" : "left",
      fontSize: isMobile ? "11px" : "12px",
      itemMargin: {
        horizontal: 8,
        vertical: 4,
      },
    },
    plotOptions: {
      pie: {
        donut: {
          size: isTabletOrMobile ? "60%" : "68%",
        },
      },
    },
    tooltip: {
      y: {
        formatter: function (val) {
          return formatDashboardCurrency(val);
        },
      },
    },
    noData: {
      text: "Sem dados",
    },
  };

  dashboardChannelChart = new ApexCharts(
    document.querySelector("#dashboardChannelChart"),
    options,
  );
  dashboardChannelChart.render();
}

function renderDashboardTopProducts(topProducts) {
  if (!$("#dashboardTopProductsTableBody").length) {
    return;
  }

  var hasData = Array.isArray(topProducts) && topProducts.length > 0;
  if (!hasData) {
    if (
      $.fn.DataTable &&
      $.fn.DataTable.isDataTable("#dashboardTopProductsTable")
    ) {
      $("#dashboardTopProductsTable").DataTable().clear().destroy();
    }

    $("#dashboardTopProductsTableBody").html(
      "<tr>" +
        "<td class='text-center text-muted'>Sem dados disponíveis.</td>" +
        "<td></td>" +
        "<td></td>" +
        "</tr>",
    );
    return;
  }

  /* Destroy existing DT before replacing tbody HTML */
  if (
    $.fn.DataTable &&
    $.fn.DataTable.isDataTable("#dashboardTopProductsTable")
  ) {
    $("#dashboardTopProductsTable").DataTable().clear().destroy();
  }

  var html = "";
  for (var i = 0; i < topProducts.length; i++) {
    var product = topProducts[i];
    html +=
      "<tr>" +
      "<td>" +
      (product.label || "Desconhecido") +
      "</td>" +
      "<td>" +
      formatDashboardCurrency(product.revenue) +
      "</td>" +
      "<td>" +
      formatDashboardInt(product.quantity) +
      "</td>" +
      "</tr>";
  }

  $("#dashboardTopProductsTableBody").html(html);
  initDashboardStatsDataTable("dashboardTopProductsTable");
}

function renderDashboardCities(cities) {
  if (!$("#dashboardCitiesTableBody").length) {
    return;
  }

  var hasData = Array.isArray(cities) && cities.length > 0;
  if (!hasData) {
    if ($.fn.DataTable && $.fn.DataTable.isDataTable("#dashboardCitiesTable")) {
      $("#dashboardCitiesTable").DataTable().clear().destroy();
    }

    $("#dashboardCitiesTableBody").html(
      "<tr>" +
        "<td class='text-center text-muted'>Sem dados disponíveis.</td>" +
        "<td></td>" +
        "</tr>",
    );
    return;
  }

  /* Destroy existing DT before replacing tbody HTML */
  if ($.fn.DataTable && $.fn.DataTable.isDataTable("#dashboardCitiesTable")) {
    $("#dashboardCitiesTable").DataTable().clear().destroy();
  }

  var html = "";
  for (var i = 0; i < cities.length; i++) {
    var city = cities[i];
    html +=
      "<tr>" +
      "<td>" +
      (city.label || "Desconhecido") +
      "</td>" +
      "<td>" +
      formatDashboardCurrency(city.revenue) +
      "</td>" +
      "</tr>";
  }

  $("#dashboardCitiesTableBody").html(html);
  initDashboardStatsDataTable("dashboardCitiesTable");
}

function getDashboardResponsiveOptions(tableId, nonOrderableTargets) {
  var options = {
    autoWidth: false,
    scrollX: false,
    responsive: false,
    cardViewportMax: DASHBOARD_BREAKPOINTS.compactMax,
    drawCallback: function () {
      applyDashboardCardLabels(tableId);
    },
  };

  if (Array.isArray(nonOrderableTargets) && nonOrderableTargets.length > 0) {
    options.columnDefs = [
      {
        targets: nonOrderableTargets,
        orderable: false,
        searchable: false,
      },
    ];
  }

  return options;
}

/**
 * Adds data-label attributes to every <td> in the table body
 * so the CSS card layout can display "Label: Value" pairs on mobile.
 * Runs on every DT draw (init, paginate, search, sort).
 */
function applyDashboardCardLabels(tableId) {
  var $table = $("#" + tableId);
  if (!$table.length) return;

  var headers = [];
  $table.find("thead th").each(function () {
    var $clone = $(this).clone();
    $clone.find("i, svg, .fa, .fas, .far, .fab, .fal, .fad").remove();
    headers.push($.trim($clone.text()));
  });

  $table.find("tbody > tr").each(function () {
    var $row = $(this);
    if ($row.hasClass("dt-empty") || $row.find("td[colspan]").length) return;
    $row.children("td").each(function (idx) {
      /* Skip selection column — handled as overlay in card view */
      if ($(this).hasClass("dashboard-bulk-select-col")) return;
      if (idx < headers.length && headers[idx]) {
        $(this).attr("data-label", headers[idx]);
      }
    });
  });
}

function initDashboardStatsDataTables() {
  initDashboardStatsDataTable("dashboardTopProductsTable");
  initDashboardStatsDataTable("dashboardCitiesTable");
}

/**
 * Initialise (or re-initialise) a single stats-panel DataTable.
 * Safe to call even if the table does not exist on the page.
 */
function initDashboardStatsDataTable(tableId) {
  if (!$.fn.DataTable) {
    return;
  }

  var $tbl = $("#" + tableId);
  if (!$tbl.length) {
    return;
  }

  /* Skip if already a DT — the render function is responsible for
     destroying before repopulating the tbody.                      */
  if ($.fn.DataTable.isDataTable("#" + tableId)) {
    return;
  }

  createDataTable(
    tableId,
    false,
    "",
    false,
    10,
    [],
    true,
    false,
    getDashboardResponsiveOptions(tableId),
  );
}

function renderDashboardVendasTable(arrayVendas) {
  dashboardVendasRowsById = {};
  var tableBody = "";
  var canEdit = $("#dashboardVendaCanEdit").val() === "1";
  var canDelete = $("#dashboardVendaCanDelete").val() === "1";
  var showActions = canEdit;

  if ($.fn.DataTable && $.fn.DataTable.isDataTable("#dashboardVendasTable")) {
    $("#dashboardVendasTable").DataTable().clear().destroy();
  }

  for (var index = 0; index < arrayVendas.length; index++) {
    var venda = arrayVendas[index];
    var vendaId = venda.id != null ? venda.id : "";
    var vendaIdVenda = venda.id_venda != null ? venda.id_venda : "";
    var dataHora = venda.DataHora != null ? venda.DataHora : "";
    var produto = venda.produto != null ? venda.produto : "";
    var categoria = venda.categoria != null ? venda.categoria : "";
    var quantidade = venda.quantidade != null ? venda.quantidade : "";
    var total = venda.total != null ? formatDashboardCurrency(venda.total) : "";
    var canal = venda.canal_venda != null ? venda.canal_venda : "";
    var cidade = venda.cidade != null ? venda.cidade : "";

    if (vendaId !== "") {
      dashboardVendasRowsById[vendaId] = venda;
    }

    var actionsHtml = "";
    if (canEdit && vendaId !== "") {
      actionsHtml +=
        "<a class='btn btn-primary btn-xs dashboard-row-edit-btn' title='Editar' onclick='editDashboardVenda(" +
        vendaId +
        ")'><i class='fas fa-edit'></i> Editar</a>";
    }

    tableBody +=
      "<tr>" +
      (canDelete
        ? "<td class='text-center dashboard-bulk-select-col'><input type='checkbox' class='dashboard-bulk-row-select dashboard-vendas-row-select' data-id='" +
          vendaId +
          "'></td>"
        : "") +
      "<td>" +
      vendaIdVenda +
      "</td>" +
      "<td>" +
      dataHora +
      "</td>" +
      "<td>" +
      produto +
      "</td>" +
      "<td>" +
      categoria +
      "</td>" +
      "<td>" +
      quantidade +
      "</td>" +
      "<td>" +
      total +
      "</td>" +
      "<td>" +
      canal +
      "</td>" +
      "<td>" +
      cidade +
      "</td>" +
      (showActions
        ? "<td class='text-nowrap dashboard-actions-col'>" +
          actionsHtml +
          "</td>"
        : "") +
      "</tr>";
  }

  if (tableBody === "") {
    tableBody = "";
  }

  $("#dashboardVendasTableBody").html(tableBody);
  $("#dashboardVendasTable").toggleClass("dashboard-no-actions", !showActions);
  if ($.fn.DataTable && !$.fn.DataTable.isDataTable("#dashboardVendasTable")) {
    var vendasTableOptions = getDashboardResponsiveOptions(
      "dashboardVendasTable",
      canDelete ? [0] : [],
    );
    vendasTableOptions.order = [[canDelete ? 1 : 0, "desc"]];

    createDataTable(
      "dashboardVendasTable",
      false,
      "",
      false,
      10,
      [],
      true,
      false,
      vendasTableOptions,
    );
  }
  clearDashboardTableGlobalSearch("dashboardVendasTable");
  initializeDashboardVendasSelectFilters();
  applyDashboardVendasFilters();
  bindDashboardBulkSelectionHandlers(
    "dashboardVendasTable",
    "dashboard-vendas-row-select",
    "dashboardVendasSelectAll",
    "dashboardVendasDeleteSelectedBtn",
  );
}

var dashboardVendasFilterFn = null;
var dashboardVendasDateRange = { start: "", end: "" };
var dashboardVendasRowsById = {};
var dashboardVendasCascadeSyncing = false;

function getDashboardVendasTable() {
  if (!$.fn.DataTable || !$.fn.DataTable.isDataTable("#dashboardVendasTable")) {
    return null;
  }
  return $("#dashboardVendasTable").DataTable();
}

function clearDashboardTableGlobalSearch(tableId) {
  if (!$.fn.DataTable || !$.fn.DataTable.isDataTable("#" + tableId)) {
    return;
  }

  var table = $("#" + tableId).DataTable();
  if (!table || typeof table.search !== "function") {
    return;
  }

  if (table.search() !== "") {
    table.search("");
    $("#" + tableId + "_filter input[type='search']").val("");
    table.draw(false);
  }
}

function normalizeDashboardVendasFilterArray(values) {
  if (!Array.isArray(values)) {
    return [];
  }

  return values
    .map(function (value) {
      return (value || "").toString().trim().toLowerCase();
    })
    .filter(function (value) {
      return value !== "";
    });
}

function getDashboardVendasRowsArray() {
  var rows = [];
  for (var id in dashboardVendasRowsById) {
    if (Object.prototype.hasOwnProperty.call(dashboardVendasRowsById, id)) {
      rows.push(dashboardVendasRowsById[id]);
    }
  }
  return rows;
}

function syncDashboardVendasDependentFilters(changedFilterId) {
  if (dashboardVendasCascadeSyncing) {
    return;
  }

  var $categoria = $("#dashboardVendasCategoria");
  var $cidade = $("#dashboardVendasCidade");
  var $canal = $("#dashboardVendasCanal");

  if (!$categoria.length || !$cidade.length || !$canal.length) {
    return;
  }

  var categoriasSel = normalizeDashboardVendasFilterArray($categoria.val());
  var cidadesSel = normalizeDashboardVendasFilterArray($cidade.val());
  var canaisSel = normalizeDashboardVendasFilterArray($canal.val());
  var startDate = ($("#dashboardVendasStartDate").val() || "").trim();
  var endDate = ($("#dashboardVendasEndDate").val() || "").trim();
  var rows = getDashboardVendasRowsArray();

  function rowMatchesDate(row) {
    var rowDate =
      row && row.DataHora ? row.DataHora.toString().substring(0, 10) : "";
    if (startDate !== "" && rowDate < startDate) {
      return false;
    }
    if (endDate !== "" && rowDate > endDate) {
      return false;
    }
    return true;
  }

  var allowedCategoriasMap = {};
  var allowedCidadesMap = {};
  var allowedCanaisMap = {};

  for (var i = 0; i < rows.length; i++) {
    var row = rows[i] || {};
    if (!rowMatchesDate(row)) {
      continue;
    }

    var categoriaRaw =
      row.categoria != null ? row.categoria.toString().trim() : "";
    var categoria = categoriaRaw.toLowerCase();
    var cidadeRaw = row.cidade != null ? row.cidade.toString().trim() : "";
    var cidade = cidadeRaw.toLowerCase();
    var canalRaw =
      row.canal_venda != null ? row.canal_venda.toString().trim() : "";
    var canal = canalRaw.toLowerCase();

    if (
      (cidadesSel.length === 0 || cidadesSel.indexOf(cidade) > -1) &&
      (canaisSel.length === 0 || canaisSel.indexOf(canal) > -1) &&
      categoriaRaw !== ""
    ) {
      allowedCategoriasMap[categoriaRaw] = true;
    }

    if (
      (categoriasSel.length === 0 || categoriasSel.indexOf(categoria) > -1) &&
      (canaisSel.length === 0 || canaisSel.indexOf(canal) > -1) &&
      cidadeRaw !== ""
    ) {
      allowedCidadesMap[cidadeRaw] = true;
    }

    if (
      (categoriasSel.length === 0 || categoriasSel.indexOf(categoria) > -1) &&
      (cidadesSel.length === 0 || cidadesSel.indexOf(cidade) > -1) &&
      canalRaw !== ""
    ) {
      allowedCanaisMap[canalRaw] = true;
    }
  }

  var allowedCategorias = Object.keys(allowedCategoriasMap).sort(
    function (a, b) {
      return a.localeCompare(b, "pt", { sensitivity: "base" });
    },
  );
  var allowedCidades = Object.keys(allowedCidadesMap).sort(function (a, b) {
    return a.localeCompare(b, "pt", { sensitivity: "base" });
  });
  var allowedCanais = Object.keys(allowedCanaisMap).sort(function (a, b) {
    return a.localeCompare(b, "pt", { sensitivity: "base" });
  });

  function applyMultiOptions($select, options) {
    var selected = Array.isArray($select.val()) ? $select.val() : [];
    var selectedMap = {};
    for (var idx = 0; idx < selected.length; idx++) {
      selectedMap[selected[idx].toString().trim().toLowerCase()] = true;
    }

    var validSelected = [];
    $select.empty();

    for (var j = 0; j < options.length; j++) {
      var optionValue = options[j];
      var optionLower = optionValue.toString().trim().toLowerCase();
      var isSelected = selectedMap[optionLower] === true;

      $select.append($("<option></option>").val(optionValue).text(optionValue));
      if (isSelected) {
        validSelected.push(optionValue);
      }
    }

    $select.val(validSelected);
    if ($select.hasClass("select2-hidden-accessible")) {
      $select.trigger("change.select2");
    }
  }

  dashboardVendasCascadeSyncing = true;

  if (changedFilterId !== "dashboardVendasCategoria") {
    applyMultiOptions($categoria, allowedCategorias);
  }
  if (changedFilterId !== "dashboardVendasCidade") {
    applyMultiOptions($cidade, allowedCidades);
  }
  if (changedFilterId !== "dashboardVendasCanal") {
    applyMultiOptions($canal, allowedCanais);
  }

  dashboardVendasCascadeSyncing = false;
}

function initializeDashboardVendasSelectFilters() {
  if (!$.fn.select2) {
    return;
  }

  var filterSelectors = [
    "#dashboardVendasCategoria",
    "#dashboardVendasCidade",
    "#dashboardVendasCanal",
  ];

  for (var i = 0; i < filterSelectors.length; i++) {
    var selector = filterSelectors[i];
    var $filter = $(selector);
    if (!$filter.length) {
      continue;
    }

    if ($filter.hasClass("select2-hidden-accessible")) {
      $filter.select2("destroy");
    }

    $filter.select2({
      placeholder: $filter.attr("data-placeholder") || "Selecionar",
      width: "100%",
      closeOnSelect: false,
      allowClear: true,
      dropdownAutoWidth: true,
    });
  }

  $(
    "#dashboardVendasCategoria, #dashboardVendasCidade, #dashboardVendasCanal, #dashboardVendasStartDate, #dashboardVendasEndDate",
  )
    .off("change.dashboardVendasCascade")
    .on("change.dashboardVendasCascade", function () {
      if (dashboardVendasCascadeSyncing) {
        return;
      }
      syncDashboardVendasDependentFilters(this.id);
    });

  syncDashboardVendasDependentFilters("");
}

function applyDashboardVendasFilters() {
  var table = getDashboardVendasTable();
  if (!table) {
    return;
  }

  var filtros = getDashboardVendasFiltersPayload();
  var startDate = filtros.startDate;
  var endDate = filtros.endDate;
  var categoria = filtros.categoria;
  var cidade = filtros.cidade;
  var canal = filtros.canal;

  dashboardVendasDateRange.start = startDate;
  dashboardVendasDateRange.end = endDate;

  var categoriaFiltros = Array.isArray(categoria)
    ? categoria
        .map(function (item) {
          return (item || "").toString().trim().toLowerCase();
        })
        .filter(function (item) {
          return item !== "";
        })
    : [];
  var cidadeFiltros = Array.isArray(cidade)
    ? cidade
        .map(function (item) {
          return (item || "").toString().trim().toLowerCase();
        })
        .filter(function (item) {
          return item !== "";
        })
    : [];
  var canalFiltros = Array.isArray(canal)
    ? canal
        .map(function (item) {
          return (item || "").toString().trim().toLowerCase();
        })
        .filter(function (item) {
          return item !== "";
        })
    : [];
  var canDelete = $("#dashboardVendaCanDelete").val() === "1";
  var colOffset = canDelete ? 1 : 0;

  if (dashboardVendasFilterFn !== null) {
    var idx = $.fn.dataTable.ext.search.indexOf(dashboardVendasFilterFn);
    if (idx > -1) {
      $.fn.dataTable.ext.search.splice(idx, 1);
    }
  }

  dashboardVendasFilterFn = function (settings, data) {
    if (
      !settings ||
      !settings.nTable ||
      settings.nTable.id !== "dashboardVendasTable"
    ) {
      return true;
    }

    var rowDate = data[colOffset + 1]
      ? data[colOffset + 1].toString().substring(0, 10)
      : "";
    var rowCategoria = data[colOffset + 3]
      ? data[colOffset + 3].toString().trim().toLowerCase()
      : "";
    var rowCanal = data[colOffset + 6]
      ? data[colOffset + 6].toString().trim().toLowerCase()
      : "";
    var rowCidade = data[colOffset + 7]
      ? data[colOffset + 7].toString().trim().toLowerCase()
      : "";

    if (
      categoriaFiltros.length > 0 &&
      categoriaFiltros.indexOf(rowCategoria) === -1
    ) {
      return false;
    }
    if (cidadeFiltros.length > 0 && cidadeFiltros.indexOf(rowCidade) === -1) {
      return false;
    }
    if (canalFiltros.length > 0 && canalFiltros.indexOf(rowCanal) === -1) {
      return false;
    }
    if (
      dashboardVendasDateRange.start !== "" &&
      rowDate < dashboardVendasDateRange.start
    ) {
      return false;
    }
    if (
      dashboardVendasDateRange.end !== "" &&
      rowDate > dashboardVendasDateRange.end
    ) {
      return false;
    }

    return true;
  };

  $.fn.dataTable.ext.search.push(dashboardVendasFilterFn);
  table.draw();
}

function getDashboardVendasFiltersPayload() {
  var categoriaSelecionada = $("#dashboardVendasCategoria").val();
  var cidadeSelecionada = $("#dashboardVendasCidade").val();
  var canalSelecionado = $("#dashboardVendasCanal").val();

  return {
    startDate: ($("#dashboardVendasStartDate").val() || "").trim(),
    endDate: ($("#dashboardVendasEndDate").val() || "").trim(),
    categoria: Array.isArray(categoriaSelecionada) ? categoriaSelecionada : [],
    cidade: Array.isArray(cidadeSelecionada) ? cidadeSelecionada : [],
    canal: Array.isArray(canalSelecionado) ? canalSelecionado : [],
  };
}

function clearDashboardVendasFilters() {
  $("#dashboardVendasStartDate").val("");
  $("#dashboardVendasEndDate").val("");
  $("#dashboardVendasCategoria").val([]).trigger("change");
  $("#dashboardVendasCidade").val([]).trigger("change");
  $("#dashboardVendasCanal").val([]).trigger("change");

  syncDashboardVendasDependentFilters("");

  var table = getDashboardVendasTable();
  if (!table) {
    return;
  }

  dashboardVendasDateRange.start = "";
  dashboardVendasDateRange.end = "";

  if (dashboardVendasFilterFn !== null) {
    var idx = $.fn.dataTable.ext.search.indexOf(dashboardVendasFilterFn);
    if (idx > -1) {
      $.fn.dataTable.ext.search.splice(idx, 1);
    }
    dashboardVendasFilterFn = null;
  }

  table.draw();
}

function openDashboardVendaModal() {
  var now = new Date();
  var localDateTime = new Date(now.getTime() - now.getTimezoneOffset() * 60000)
    .toISOString()
    .slice(0, 16);

  $("#dashboardVendaRowId").val("");
  $("#dashboardVendaProduto").val("");
  $("#dashboardVendaCidade").val("");
  $("#dashboardVendaCategoria").val("");
  $("#dashboardVendaCanal").val("");
  $("#dashboardVendaQuantidade").val("1");
  $("#dashboardVendaDataHora").val(localDateTime);
  $("#dashboardVendaModal .modal-title").text("Adicionar venda");
  $("#dashboardVendaSaveBtn").html(
    "<i class='fas fa-check mr-1'></i>Guardar venda",
  );
  $("#dashboardVendaModal").modal("show");
}

function editDashboardVenda(vendaId) {
  var venda = dashboardVendasRowsById[vendaId];
  if (!venda) {
    toaster("Venda não encontrada para edição.", "warning");
    return;
  }

  var dataHora = (venda.DataHora || "").toString();
  var dataHoraLocal = "";
  if (dataHora.length >= 16) {
    dataHoraLocal = dataHora.substring(0, 16).replace(" ", "T");
  }

  $("#dashboardVendaRowId").val(venda.id || "");
  $("#dashboardVendaProduto").val(venda.id_produto || "");
  $("#dashboardVendaCidade").val(venda.id_cidade || "");
  $("#dashboardVendaCategoria").val(venda.id_categoria || "");
  var canalVenda = (venda.canal_venda || "").toString().trim();
  var canalOptionExists =
    canalVenda !== "" &&
    $("#dashboardVendaCanal option").filter(function () {
      return ($(this).val() || "") + "" === canalVenda;
    }).length > 0;
  if (canalVenda !== "" && !canalOptionExists) {
    $("#dashboardVendaCanal").append(
      "<option value='" +
        $("<div>").text(canalVenda).html().replace(/'/g, "&#39;") +
        "'>" +
        $("<div>").text(canalVenda).html() +
        "</option>",
    );
  }
  $("#dashboardVendaCanal").val(canalVenda);
  $("#dashboardVendaQuantidade").val(venda.quantidade || 0);
  $("#dashboardVendaDataHora").val(dataHoraLocal);
  $("#dashboardVendaModal .modal-title").text("Editar venda");
  $("#dashboardVendaSaveBtn").html(
    "<i class='fas fa-check mr-1'></i>Atualizar venda",
  );
  $("#dashboardVendaModal").modal("show");
}

async function saveDashboardVenda() {
  var rowId = parseInt($("#dashboardVendaRowId").val(), 10);
  var idProduto = parseInt($("#dashboardVendaProduto").val(), 10);
  var idCidade = parseInt($("#dashboardVendaCidade").val(), 10);
  var idCategoria = parseInt($("#dashboardVendaCategoria").val(), 10);
  var dataHora = ($("#dashboardVendaDataHora").val() || "").trim();
  var quantidade = parseInt($("#dashboardVendaQuantidade").val(), 10);
  var canalVenda = ($("#dashboardVendaCanal").val() || "").trim();

  if (
    isNaN(idProduto) ||
    idProduto <= 0 ||
    isNaN(idCidade) ||
    idCidade <= 0 ||
    isNaN(idCategoria) ||
    idCategoria <= 0 ||
    dataHora === "" ||
    isNaN(quantidade) ||
    quantidade < 0 ||
    canalVenda === ""
  ) {
    toaster("Preencha todos os campos obrigatórios da venda.", "warning");
    return;
  }

  var isEdit = !isNaN(rowId) && rowId > 0;
  var backendFunction = isEdit ? "updateDashboardVenda" : "addDashboardVenda";
  var payload = {
    id_produto: idProduto,
    id_cidade: idCidade,
    id_categoria: idCategoria,
    data_hora: dataHora,
    quantidade: quantidade,
    canal_venda: canalVenda,
  };
  if (isEdit) {
    payload.id = rowId;
  }

  showDashboardLoadingAlert(
    isEdit ? "A atualizar venda" : "A adicionar venda",
    "Aguarde, estamos a guardar os dados...",
  );

  try {
    var response = await $.ajax({
      type: "POST",
      url: "connect.php",
      dataType: "text",
      headers: {
        Authorization: "Bearer " + md5(localStorage.getItem("sessionObject")),
      },
      data: {
        package: overal({
          origin: "module/core/php/dashboarddb.php",
          function: backendFunction,
          attr: JSON.stringify(payload),
        }),
      },
    });
    var obj = parseDashboardResponse(response);
    if (obj.val == 1) {
      toaster(obj.msg, "success");
      closeDashboardModalAndRefresh("#dashboardVendaModal", function () {
        reloadDashboardPage();
      });
    } else {
      toaster(obj.msg || "Erro ao guardar venda.", "error");
    }
  } catch (error) {
    toaster(
      "Erro ao guardar venda: " + (error.statusText || error.message || error),
      "error",
    );
  } finally {
    closeDashboardLoadingAlert();
  }
}

function confirmDeleteSelectedDashboardVendas() {
  modconf(
    "Tem a certeza que deseja eliminar as vendas selecionadas?",
    "deleteSelectedDashboardVendas()",
  );
}

async function deleteSelectedDashboardVendas() {
  await deleteDashboardSelectedRows({
    tableId: "dashboardVendasTable",
    rowSelectorClass: "dashboard-vendas-row-select",
    backendFunction: "deleteDashboardVendaBulk",
    esc: 3,
  });
}

async function downloadDashboardVendasPdf() {
  var filtros = getDashboardVendasFiltersPayload();

  showDashboardLoadingAlert(
    "A gerar PDF",
    "Aguarde, estamos a preparar o relatório...",
  );

  try {
    var response = await $.ajax({
      type: "POST",
      url: "connect.php",
      dataType: "text",
      headers: {
        Authorization: "Bearer " + md5(localStorage.getItem("sessionObject")),
      },
      data: {
        package: overal({
          origin: "module/core/php/dashboarddb.php",
          function: "exportDashboardVendasPdf",
          attr: JSON.stringify(filtros),
        }),
      },
    });

    var obj = parseDashboardResponse(response);
    if (obj.val == 1) {
      toaster(obj.msg, "success");
      if (obj.link) {
        window.open(obj.link, "_blank");
      }
    } else {
      toaster(obj.msg || "Erro ao gerar PDF.", "warning");
    }
  } catch (error) {
    toaster(
      "Erro ao gerar PDF: " + (error.statusText || error.message || error),
      "error",
    );
  } finally {
    closeDashboardLoadingAlert();
  }
}

function renderDashboardProdutosTable(arrayProdutos) {
  dashboardProdutosRowsById = {};
  var tableBody = "";
  var minPreco = Number.POSITIVE_INFINITY;
  var maxPreco = Number.NEGATIVE_INFINITY;
  var canEdit = $("#dashboardProdutoCanEdit").val() === "1";
  var canDelete = $("#dashboardProdutoCanDelete").val() === "1";
  var showActions = canEdit;

  if ($.fn.DataTable && $.fn.DataTable.isDataTable("#dashboardProdutosTable")) {
    $("#dashboardProdutosTable").DataTable().clear().destroy();
  }

  for (var index = 0; index < arrayProdutos.length; index++) {
    var produto = arrayProdutos[index];
    var idProduto = produto.id != null ? produto.id : "";
    var descricao = produto.descricao != null ? produto.descricao : "";
    var tipoProduto = produto.tipo_produto != null ? produto.tipo_produto : "";
    var precoUnitario =
      produto.preco_uni != null
        ? formatDashboardCurrency(produto.preco_uni)
        : "";
    var createdAt = produto.created_at != null ? produto.created_at : "";
    var updatedAt = produto.updated_at != null ? produto.updated_at : "";

    if (idProduto !== "") {
      dashboardProdutosRowsById[idProduto] = produto;
    }

    var precoRaw = parseFloat(produto.preco_uni);
    if (!isNaN(precoRaw)) {
      if (precoRaw < minPreco) {
        minPreco = precoRaw;
      }
      if (precoRaw > maxPreco) {
        maxPreco = precoRaw;
      }
    }

    var actionsHtml = "";
    if (canEdit && idProduto !== "") {
      actionsHtml +=
        "<a class='btn btn-primary btn-xs dashboard-row-edit-btn' title='Editar' onclick='editDashboardProduto(" +
        idProduto +
        ")'><i class='fas fa-edit'></i> Editar</a>";
    }

    tableBody +=
      "<tr>" +
      (canDelete
        ? "<td class='text-center dashboard-bulk-select-col'><input type='checkbox' class='dashboard-bulk-row-select dashboard-produtos-row-select' data-id='" +
          idProduto +
          "'></td>"
        : "") +
      "<td class='dashboard-produtos-col-id'>" +
      idProduto +
      "</td>" +
      "<td class='dashboard-produtos-col-produto'>" +
      descricao +
      "</td>" +
      "<td class='dashboard-produtos-col-tipo'>" +
      tipoProduto +
      "</td>" +
      "<td class='dashboard-produtos-col-preco'>" +
      precoUnitario +
      "</td>" +
      "<td class='dashboard-produtos-col-criado'>" +
      createdAt +
      "</td>" +
      "<td class='dashboard-produtos-col-atualizado'>" +
      updatedAt +
      "</td>" +
      (showActions
        ? "<td class='text-nowrap dashboard-actions-col'>" +
          actionsHtml +
          "</td>"
        : "") +
      "</tr>";
  }

  if (tableBody === "") {
    tableBody = "";
  }

  $("#dashboardProdutosTableBody").html(tableBody);
  $("#dashboardProdutosTable").toggleClass(
    "dashboard-no-actions",
    !showActions,
  );
  if (
    $.fn.DataTable &&
    !$.fn.DataTable.isDataTable("#dashboardProdutosTable")
  ) {
    createDataTable(
      "dashboardProdutosTable",
      false,
      "",
      false,
      10,
      [],
      true,
      false,
      getDashboardResponsiveOptions(
        "dashboardProdutosTable",
        canDelete ? [0] : [],
      ),
    );
  }
  clearDashboardTableGlobalSearch("dashboardProdutosTable");
  setDashboardProdutosPriceBounds(minPreco, maxPreco, true);
  initializeDashboardProdutosSelectFilters();
  applyDashboardProdutosFilters();
  bindDashboardBulkSelectionHandlers(
    "dashboardProdutosTable",
    "dashboard-produtos-row-select",
    "dashboardProdutosSelectAll",
    "dashboardProdutosDeleteSelectedBtn",
  );
}

var dashboardProdutosFilterFn = null;
var dashboardProdutosRowsById = {};
var dashboardProdutosCascadeSyncing = false;
var dashboardProdutosPriceBounds = { min: null, max: null };

function getDashboardProdutosTable() {
  if (
    !$.fn.DataTable ||
    !$.fn.DataTable.isDataTable("#dashboardProdutosTable")
  ) {
    return null;
  }
  return $("#dashboardProdutosTable").DataTable();
}

function normalizeDashboardProdutosFilterArray(values) {
  if (!Array.isArray(values)) {
    return [];
  }

  return values
    .map(function (value) {
      return (value || "").toString().trim().toLowerCase();
    })
    .filter(function (value) {
      return value !== "";
    });
}

function normalizeDashboardSearchTerm(value) {
  return (value || "")
    .toString()
    .trim()
    .toLowerCase()
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "");
}

function getDashboardProdutosRowsArray() {
  var rows = [];
  for (var id in dashboardProdutosRowsById) {
    if (Object.prototype.hasOwnProperty.call(dashboardProdutosRowsById, id)) {
      rows.push(dashboardProdutosRowsById[id]);
    }
  }
  return rows;
}

function setDashboardProdutosPriceBounds(minValue, maxValue, forceValues) {
  var $precoMin = $("#dashboardProdutosPrecoMin");
  var $precoMax = $("#dashboardProdutosPrecoMax");

  if (!$precoMin.length || !$precoMax.length) {
    return;
  }

  var min = parseFloat(minValue);
  var max = parseFloat(maxValue);

  if (isNaN(min) || isNaN(max)) {
    dashboardProdutosPriceBounds.min = null;
    dashboardProdutosPriceBounds.max = null;
    $precoMin.removeAttr("min").removeAttr("max");
    $precoMax.removeAttr("min").removeAttr("max");
    return;
  }

  dashboardProdutosPriceBounds.min = min;
  dashboardProdutosPriceBounds.max = max;

  $precoMin.attr("min", min.toFixed(2)).attr("max", max.toFixed(2));
  $precoMax.attr("min", min.toFixed(2)).attr("max", max.toFixed(2));

  if (forceValues) {
    $precoMin.val(min.toFixed(2));
    $precoMax.val(max.toFixed(2));
  }
}

function clampDashboardProdutosPriceInputs() {
  var $precoMin = $("#dashboardProdutosPrecoMin");
  var $precoMax = $("#dashboardProdutosPrecoMax");

  if (!$precoMin.length || !$precoMax.length) {
    return;
  }

  var globalMin = dashboardProdutosPriceBounds.min;
  var globalMax = dashboardProdutosPriceBounds.max;
  if (globalMin === null || globalMax === null) {
    return;
  }

  var minVal = parseDashboardLocaleNumber($precoMin.val() || "");
  var maxVal = parseDashboardLocaleNumber($precoMax.val() || "");

  if (!isNaN(minVal)) {
    var minUpperBound = !isNaN(maxVal)
      ? Math.min(globalMax, maxVal)
      : globalMax;
    minVal = Math.max(globalMin, Math.min(minVal, minUpperBound));
    $precoMin.val(minVal.toFixed(2));
  }

  if (!isNaN(maxVal)) {
    var maxLowerBound = !isNaN(minVal)
      ? Math.max(globalMin, minVal)
      : globalMin;
    maxVal = Math.max(maxLowerBound, Math.min(maxVal, globalMax));
    $precoMax.val(maxVal.toFixed(2));
  }
}

function configureDashboardProdutosPriceInputs() {
  var $precoMin = $("#dashboardProdutosPrecoMin");
  var $precoMax = $("#dashboardProdutosPrecoMax");

  if (!$precoMin.length || !$precoMax.length) {
    return;
  }

  $precoMin
    .off(
      "wheel.dashboardProdutosPrice keydown.dashboardProdutosPrice blur.dashboardProdutosPrice change.dashboardProdutosPrice",
    )
    .on("wheel.dashboardProdutosPrice", function (event) {
      event.preventDefault();
      this.blur();
    })
    .on("keydown.dashboardProdutosPrice", function (event) {
      if (event.key === "ArrowUp" || event.key === "ArrowDown") {
        event.preventDefault();
      }
    })
    .on(
      "blur.dashboardProdutosPrice change.dashboardProdutosPrice",
      function () {
        clampDashboardProdutosPriceInputs();
      },
    );

  $precoMax
    .off(
      "wheel.dashboardProdutosPrice keydown.dashboardProdutosPrice blur.dashboardProdutosPrice change.dashboardProdutosPrice",
    )
    .on("wheel.dashboardProdutosPrice", function (event) {
      event.preventDefault();
      this.blur();
    })
    .on("keydown.dashboardProdutosPrice", function (event) {
      if (event.key === "ArrowUp" || event.key === "ArrowDown") {
        event.preventDefault();
      }
    })
    .on(
      "blur.dashboardProdutosPrice change.dashboardProdutosPrice",
      function () {
        clampDashboardProdutosPriceInputs();
      },
    );
}

function validateDashboardProdutosPriceRange(showToast) {
  var precoMinRaw = $("#dashboardProdutosPrecoMin").val() || "";
  var precoMaxRaw = $("#dashboardProdutosPrecoMax").val() || "";
  var precoMin = parseDashboardLocaleNumber(precoMinRaw);
  var precoMax = parseDashboardLocaleNumber(precoMaxRaw);

  if (!isNaN(precoMin) && precoMin < 0) {
    if (showToast) {
      toaster("O preço mínimo não pode ser negativo.", "warning");
    }
    return false;
  }

  if (!isNaN(precoMax) && precoMax < 0) {
    if (showToast) {
      toaster("O preço máximo não pode ser negativo.", "warning");
    }
    return false;
  }

  var globalMin = dashboardProdutosPriceBounds.min;
  var globalMax = dashboardProdutosPriceBounds.max;
  if (globalMin !== null && !isNaN(precoMin) && precoMin < globalMin) {
    if (showToast) {
      toaster(
        "O preço mínimo não pode ser inferior a " +
          globalMin.toFixed(2).replace(".", ",") +
          ".",
        "warning",
      );
    }
    return false;
  }

  if (globalMax !== null && !isNaN(precoMax) && precoMax > globalMax) {
    if (showToast) {
      toaster(
        "O preço máximo não pode ser superior a " +
          globalMax.toFixed(2).replace(".", ",") +
          ".",
        "warning",
      );
    }
    return false;
  }

  if (!isNaN(precoMin) && !isNaN(precoMax) && precoMin > precoMax) {
    if (showToast) {
      toaster(
        "O preço mínimo não pode ser maior que o preço máximo.",
        "warning",
      );
    }
    return false;
  }

  return true;
}

function syncDashboardProdutosDependentFilters(changedFilterId) {
  if (dashboardProdutosCascadeSyncing) {
    return;
  }

  if (!validateDashboardProdutosPriceRange(false)) {
    return;
  }

  var $produto = $("#dashboardProdutosDescricaoFilter");
  var $tipo = $("#dashboardProdutosTipoFilter");
  var $estadoVendas = $("#dashboardProdutosVendasEstado");

  if (!$produto.length || !$tipo.length || !$estadoVendas.length) {
    return;
  }

  var produtosSel = normalizeDashboardProdutosFilterArray($produto.val());
  var tiposSel = normalizeDashboardProdutosFilterArray($tipo.val());
  var estadoVendasSel = ($estadoVendas.val() || "").trim();
  var precoMin = parseDashboardLocaleNumber(
    $("#dashboardProdutosPrecoMin").val() || "",
  );
  var precoMax = parseDashboardLocaleNumber(
    $("#dashboardProdutosPrecoMax").val() || "",
  );
  var rows = getDashboardProdutosRowsArray();

  function rowMatchesEstado(row, estado) {
    var totalVendas = parseInt(row.total_vendas, 10) || 0;
    if (estado === "com") {
      return totalVendas > 0;
    }
    if (estado === "sem") {
      return totalVendas === 0;
    }
    return true;
  }

  function rowMatchesPreco(row) {
    var rowPreco = parseFloat(row.preco_uni);
    if (!isNaN(precoMin) && !isNaN(rowPreco) && rowPreco < precoMin) {
      return false;
    }
    if (!isNaN(precoMax) && !isNaN(rowPreco) && rowPreco > precoMax) {
      return false;
    }
    return true;
  }

  var allowedProdutosMap = {};
  var allowedTiposMap = {};
  for (var i = 0; i < rows.length; i++) {
    var row = rows[i] || {};
    var produtoRaw =
      row.descricao != null ? row.descricao.toString().trim() : "";
    var produto = produtoRaw.toLowerCase();
    var tipoRaw =
      row.tipo_produto != null ? row.tipo_produto.toString().trim() : "";
    var tipo = tipoRaw.toLowerCase();

    if (!rowMatchesPreco(row)) {
      continue;
    }

    if (
      (tiposSel.length === 0 || tiposSel.indexOf(tipo) > -1) &&
      rowMatchesEstado(row, estadoVendasSel) &&
      produtoRaw !== ""
    ) {
      allowedProdutosMap[produtoRaw] = true;
    }

    if (
      (produtosSel.length === 0 || produtosSel.indexOf(produto) > -1) &&
      rowMatchesEstado(row, estadoVendasSel) &&
      tipoRaw !== ""
    ) {
      allowedTiposMap[tipoRaw] = true;
    }
  }

  var allowedProdutos = Object.keys(allowedProdutosMap).sort(function (a, b) {
    return a.localeCompare(b, "pt", { sensitivity: "base" });
  });
  var allowedTipos = Object.keys(allowedTiposMap).sort(function (a, b) {
    return a.localeCompare(b, "pt", { sensitivity: "base" });
  });

  function applyMultiOptions($select, options) {
    var selected = Array.isArray($select.val()) ? $select.val() : [];
    var selectedMap = {};
    for (var idx = 0; idx < selected.length; idx++) {
      selectedMap[selected[idx].toString().trim().toLowerCase()] = true;
    }

    var validSelected = [];
    $select.empty();

    for (var j = 0; j < options.length; j++) {
      var optionValue = options[j];
      var optionLower = optionValue.toString().trim().toLowerCase();
      var isSelected = selectedMap[optionLower] === true;

      $select.append($("<option></option>").val(optionValue).text(optionValue));
      if (isSelected) {
        validSelected.push(optionValue);
      }
    }

    $select.val(validSelected);
    if ($select.hasClass("select2-hidden-accessible")) {
      $select.trigger("change.select2");
    }
  }

  dashboardProdutosCascadeSyncing = true;

  if (changedFilterId !== "dashboardProdutosDescricaoFilter") {
    applyMultiOptions($produto, allowedProdutos);
  }
  if (changedFilterId !== "dashboardProdutosTipoFilter") {
    applyMultiOptions($tipo, allowedTipos);
  }

  dashboardProdutosCascadeSyncing = false;
}

function initializeDashboardProdutosSelectFilters() {
  if (!$.fn.select2) {
    return;
  }

  var $produto = $("#dashboardProdutosDescricaoFilter");
  var $tipo = $("#dashboardProdutosTipoFilter");
  if (!$produto.length || !$tipo.length) {
    return;
  }

  if ($produto.hasClass("select2-hidden-accessible")) {
    $produto.select2("destroy");
  }

  $produto.select2({
    placeholder: $produto.attr("data-placeholder") || "Selecionar",
    width: "100%",
    closeOnSelect: false,
    allowClear: true,
    dropdownAutoWidth: true,
    matcher: function (params, data) {
      var term = normalizeDashboardSearchTerm(params.term || "");
      if (term === "") {
        return data;
      }

      var text = normalizeDashboardSearchTerm(data.text || "");
      if (text.indexOf(term) > -1) {
        return data;
      }
      return null;
    },
  });

  if ($tipo.hasClass("select2-hidden-accessible")) {
    $tipo.select2("destroy");
  }

  $tipo.select2({
    placeholder: $tipo.attr("data-placeholder") || "Selecionar",
    width: "100%",
    closeOnSelect: false,
    allowClear: true,
    dropdownAutoWidth: true,
  });

  configureDashboardProdutosPriceInputs();

  $(
    "#dashboardProdutosDescricaoFilter, #dashboardProdutosTipoFilter, #dashboardProdutosVendasEstado, #dashboardProdutosPrecoMin, #dashboardProdutosPrecoMax",
  )
    .off("change.dashboardProdutosCascade input.dashboardProdutosCascade")
    .on(
      "change.dashboardProdutosCascade input.dashboardProdutosCascade",
      function () {
        if (dashboardProdutosCascadeSyncing) {
          return;
        }
        syncDashboardProdutosDependentFilters(this.id);
      },
    );

  syncDashboardProdutosDependentFilters("");
}

function getDashboardProdutosFiltersPayload() {
  var produtoSelecionado = $("#dashboardProdutosDescricaoFilter").val();
  var tipoSelecionado = $("#dashboardProdutosTipoFilter").val();
  return {
    produtos: Array.isArray(produtoSelecionado) ? produtoSelecionado : [],
    tipos: Array.isArray(tipoSelecionado) ? tipoSelecionado : [],
    precoMin: ($("#dashboardProdutosPrecoMin").val() || "").trim(),
    precoMax: ($("#dashboardProdutosPrecoMax").val() || "").trim(),
    estadoVendas: ($("#dashboardProdutosVendasEstado").val() || "").trim(),
  };
}

function applyDashboardProdutosFilters() {
  var table = getDashboardProdutosTable();
  if (!table) {
    return;
  }

  clampDashboardProdutosPriceInputs();

  if (!validateDashboardProdutosPriceRange(true)) {
    return;
  }

  var filtros = getDashboardProdutosFiltersPayload();
  var produtosFiltro = filtros.produtos
    .map(function (item) {
      return (item || "").toString().trim().toLowerCase();
    })
    .filter(function (item) {
      return item !== "";
    });
  var tiposFiltro = filtros.tipos
    .map(function (item) {
      return (item || "").toString().trim().toLowerCase();
    })
    .filter(function (item) {
      return item !== "";
    });
  var precoMin = parseDashboardLocaleNumber(filtros.precoMin);
  var precoMax = parseDashboardLocaleNumber(filtros.precoMax);
  var estadoVendas = filtros.estadoVendas;
  var canDelete = $("#dashboardProdutoCanDelete").val() === "1";
  var colOffset = canDelete ? 1 : 0;

  if (dashboardProdutosFilterFn !== null) {
    var idx = $.fn.dataTable.ext.search.indexOf(dashboardProdutosFilterFn);
    if (idx > -1) {
      $.fn.dataTable.ext.search.splice(idx, 1);
    }
  }

  dashboardProdutosFilterFn = function (settings, data) {
    if (
      !settings ||
      !settings.nTable ||
      settings.nTable.id !== "dashboardProdutosTable"
    ) {
      return true;
    }

    var rowId = parseInt(data[colOffset], 10);
    var row = !isNaN(rowId) ? dashboardProdutosRowsById[rowId] : null;
    var rowDescricao = row
      ? (row.descricao || "").toString().trim().toLowerCase()
      : data[colOffset + 1]
        ? data[colOffset + 1].toString().trim().toLowerCase()
        : "";
    var rowTipo = row
      ? (row.tipo_produto || "").toString().trim().toLowerCase()
      : data[colOffset + 2]
        ? data[colOffset + 2].toString().trim().toLowerCase()
        : "";
    var rowPreco = row
      ? parseFloat(row.preco_uni)
      : parseDashboardLocaleNumber(data[colOffset + 3] || "");
    var totalVendas = row ? parseInt(row.total_vendas, 10) || 0 : 0;

    if (
      produtosFiltro.length > 0 &&
      produtosFiltro.indexOf(rowDescricao) === -1
    ) {
      return false;
    }
    if (tiposFiltro.length > 0 && tiposFiltro.indexOf(rowTipo) === -1) {
      return false;
    }
    if (!isNaN(precoMin) && !isNaN(rowPreco) && rowPreco < precoMin) {
      return false;
    }
    if (!isNaN(precoMax) && !isNaN(rowPreco) && rowPreco > precoMax) {
      return false;
    }
    if (estadoVendas === "com" && totalVendas < 1) {
      return false;
    }
    if (estadoVendas === "sem" && totalVendas > 0) {
      return false;
    }

    return true;
  };

  $.fn.dataTable.ext.search.push(dashboardProdutosFilterFn);
  table.draw();
}

function clearDashboardProdutosFilters() {
  $("#dashboardProdutosDescricaoFilter").val([]).trigger("change");
  $("#dashboardProdutosTipoFilter").val([]).trigger("change");
  if (
    dashboardProdutosPriceBounds.min !== null &&
    dashboardProdutosPriceBounds.max !== null
  ) {
    $("#dashboardProdutosPrecoMin").val(
      dashboardProdutosPriceBounds.min.toFixed(2),
    );
    $("#dashboardProdutosPrecoMax").val(
      dashboardProdutosPriceBounds.max.toFixed(2),
    );
  } else {
    $("#dashboardProdutosPrecoMin").val("");
    $("#dashboardProdutosPrecoMax").val("");
  }
  $("#dashboardProdutosVendasEstado").val("");

  syncDashboardProdutosDependentFilters("");

  var table = getDashboardProdutosTable();
  if (!table) {
    return;
  }

  if (dashboardProdutosFilterFn !== null) {
    var idx = $.fn.dataTable.ext.search.indexOf(dashboardProdutosFilterFn);
    if (idx > -1) {
      $.fn.dataTable.ext.search.splice(idx, 1);
    }
    dashboardProdutosFilterFn = null;
  }

  table.draw();
}

function openDashboardProdutoModal() {
  $("#dashboardProdutoRowId").val("");
  $("#dashboardProdutoDescricao").val("");
  $("#dashboardProdutoTipoProduto").val("");
  $("#dashboardProdutoPrecoUni").val("0");
  $("#dashboardProdutoModal .modal-title").text("Adicionar produto");
  $("#dashboardProdutoSaveBtn").html(
    "<i class='fas fa-check mr-1'></i>Guardar produto",
  );
  $("#dashboardProdutoModal").modal("show");
}

function editDashboardProduto(produtoId) {
  var produto = dashboardProdutosRowsById[produtoId];
  if (!produto) {
    toaster("Produto não encontrado para edição.", "warning");
    return;
  }

  $("#dashboardProdutoRowId").val(produto.id || "");
  $("#dashboardProdutoDescricao").val(produto.descricao || "");
  $("#dashboardProdutoTipoProduto").val(produto.id_tipo_produto || "");
  $("#dashboardProdutoPrecoUni").val(produto.preco_uni || 0);
  $("#dashboardProdutoModal .modal-title").text("Editar produto");
  $("#dashboardProdutoSaveBtn").html(
    "<i class='fas fa-check mr-1'></i>Atualizar produto",
  );
  $("#dashboardProdutoModal").modal("show");
}

async function saveDashboardProduto() {
  var rowId = parseInt($("#dashboardProdutoRowId").val(), 10);
  var descricao = ($("#dashboardProdutoDescricao").val() || "").trim();
  var idTipoProduto = parseInt($("#dashboardProdutoTipoProduto").val(), 10);
  var precoUni = parseFloat($("#dashboardProdutoPrecoUni").val());

  if (
    descricao === "" ||
    isNaN(idTipoProduto) ||
    idTipoProduto <= 0 ||
    isNaN(precoUni) ||
    precoUni < 0
  ) {
    toaster("Preencha todos os campos obrigatórios do produto.", "warning");
    return;
  }

  var isEdit = !isNaN(rowId) && rowId > 0;
  var backendFunction = isEdit
    ? "updateDashboardProduto"
    : "addDashboardProduto";
  var payload = {
    descricao: descricao,
    id_tipo_produto: idTipoProduto,
    preco_uni: precoUni,
  };
  if (isEdit) {
    payload.id = rowId;
  }

  showDashboardLoadingAlert(
    isEdit ? "A atualizar produto" : "A adicionar produto",
    "Aguarde, estamos a guardar os dados...",
  );

  try {
    var response = await $.ajax({
      type: "POST",
      url: "connect.php",
      dataType: "text",
      headers: {
        Authorization: "Bearer " + md5(localStorage.getItem("sessionObject")),
      },
      data: {
        package: overal({
          origin: "module/core/php/dashboarddb.php",
          function: backendFunction,
          attr: JSON.stringify(payload),
        }),
      },
    });
    var obj = parseDashboardResponse(response);
    if (obj.val == 1) {
      toaster(obj.msg, "success");
      closeDashboardModalAndRefresh("#dashboardProdutoModal", function () {
        reloadDashboardPage();
      });
    } else {
      toaster(obj.msg || "Erro ao guardar produto.", "error");
    }
  } catch (error) {
    toaster(
      "Erro ao guardar produto: " +
        (error.statusText || error.message || error),
      "error",
    );
  } finally {
    closeDashboardLoadingAlert();
  }
}

function confirmDeleteSelectedDashboardProdutos() {
  modconf(
    "Tem a certeza que deseja eliminar os produtos selecionados?",
    "deleteSelectedDashboardProdutos()",
  );
}

async function deleteSelectedDashboardProdutos() {
  await deleteDashboardSelectedRows({
    tableId: "dashboardProdutosTable",
    rowSelectorClass: "dashboard-produtos-row-select",
    backendFunction: "deleteDashboardProdutoBulk",
    esc: 4,
  });
}

async function downloadDashboardProdutosPdf() {
  var filtros = getDashboardProdutosFiltersPayload();

  showDashboardLoadingAlert(
    "A gerar PDF",
    "Aguarde, estamos a preparar o relatório...",
  );

  try {
    var response = await $.ajax({
      type: "POST",
      url: "connect.php",
      dataType: "text",
      headers: {
        Authorization: "Bearer " + md5(localStorage.getItem("sessionObject")),
      },
      data: {
        package: overal({
          origin: "module/core/php/dashboarddb.php",
          function: "exportDashboardProdutosPdf",
          attr: JSON.stringify(filtros),
        }),
      },
    });

    var obj = parseDashboardResponse(response);
    if (obj.val == 1) {
      toaster(obj.msg, "success");
      if (obj.link) {
        window.open(obj.link, "_blank");
      }
    } else {
      toaster(obj.msg || "Erro ao gerar PDF.", "warning");
    }
  } catch (error) {
    toaster(
      "Erro ao gerar PDF: " + (error.statusText || error.message || error),
      "error",
    );
  } finally {
    closeDashboardLoadingAlert();
  }
}

// --- Generic simple entity CRUD (shared by Categorias + Cidades) ---

function renderDashboardSimpleEntityTable(cfg, dataArray, rowsById) {
  var tableBody = "";
  var canEdit = $("#" + cfg.canEditInput).val() === "1";
  var canDelete = $("#" + cfg.canDeleteInput).val() === "1";
  var showActions = canEdit;

  if ($.fn.DataTable && $.fn.DataTable.isDataTable("#" + cfg.tableId)) {
    $("#" + cfg.tableId)
      .DataTable()
      .clear()
      .destroy();
  }

  for (var index = 0; index < dataArray.length; index++) {
    var item = dataArray[index];
    var itemId = item.id != null ? item.id : "";
    var descricao = item.descricao != null ? item.descricao : "";

    if (itemId !== "") {
      rowsById[itemId] = item;
    }

    var actionsHtml = "";
    if (canEdit && itemId !== "") {
      actionsHtml +=
        "<a class='btn btn-primary btn-xs dashboard-row-edit-btn' title='Editar' onclick='" +
        cfg.editFnName +
        "(" +
        itemId +
        ")'><i class='fas fa-edit'></i> Editar</a>";
    }

    tableBody +=
      "<tr>" +
      (canDelete
        ? "<td class='text-center dashboard-bulk-select-col'><input type='checkbox' class='dashboard-bulk-row-select " +
          cfg.rowSelectorClass +
          "' data-id='" +
          itemId +
          "'></td>"
        : "") +
      "<td>" +
      itemId +
      "</td>" +
      "<td>" +
      descricao +
      "</td>" +
      (showActions ? "<td class='text-nowrap'>" + actionsHtml + "</td>" : "") +
      "</tr>";
  }

  if (tableBody === "") {
    tableBody = "";
  }

  $("#" + cfg.tableBodyId).html(tableBody);
  if ($.fn.DataTable && !$.fn.DataTable.isDataTable("#" + cfg.tableId)) {
    createDataTable(
      cfg.tableId,
      false,
      "",
      false,
      10,
      [],
      true,
      false,
      getDashboardResponsiveOptions(cfg.tableId, canDelete ? [0] : []),
    );
  }
  clearDashboardTableGlobalSearch(cfg.tableId);
  bindDashboardBulkSelectionHandlers(
    cfg.tableId,
    cfg.rowSelectorClass,
    cfg.selectAllId,
    cfg.deleteBtnId,
  );
}

function openDashboardSimpleEntityModal(cfg) {
  $("#" + cfg.rowIdInput).val("");
  $("#" + cfg.descricaoInput).val("");
  $("#" + cfg.modalId + " .modal-title").text("Adicionar " + cfg.entityName);
  $("#" + cfg.saveBtnId).html(
    "<i class='fas fa-check mr-1'></i>Guardar " + cfg.entityName,
  );
  $("#" + cfg.modalId).modal("show");
}

function editDashboardSimpleEntity(cfg, entityId, rowsById) {
  var entity = rowsById[entityId];
  if (!entity) {
    toaster(cfg.entityLabel + " não encontrada para edição.", "warning");
    return;
  }

  $("#" + cfg.rowIdInput).val(entity.id || "");
  $("#" + cfg.descricaoInput).val(entity.descricao || "");
  $("#" + cfg.modalId + " .modal-title").text("Editar " + cfg.entityName);
  $("#" + cfg.saveBtnId).html(
    "<i class='fas fa-check mr-1'></i>Atualizar " + cfg.entityName,
  );
  $("#" + cfg.modalId).modal("show");
}

async function saveDashboardSimpleEntity(cfg) {
  var rowId = parseInt($("#" + cfg.rowIdInput).val(), 10);
  var descricao = ($("#" + cfg.descricaoInput).val() || "").trim();

  if (descricao === "") {
    toaster(
      "Preencha todos os campos obrigatórios da " + cfg.entityName + ".",
      "warning",
    );
    return;
  }

  var isEdit = !isNaN(rowId) && rowId > 0;
  var backendFunction = isEdit
    ? cfg.updateBackendFunction
    : cfg.addBackendFunction;
  var payload = { descricao: descricao };
  if (isEdit) {
    payload.id = rowId;
  }

  showDashboardLoadingAlert(
    isEdit ? "A atualizar " + cfg.entityName : "A adicionar " + cfg.entityName,
    "Aguarde, estamos a guardar os dados...",
  );

  try {
    var response = await $.ajax({
      type: "POST",
      url: "connect.php",
      dataType: "text",
      headers: {
        Authorization: "Bearer " + md5(localStorage.getItem("sessionObject")),
      },
      data: {
        package: overal({
          origin: "module/core/php/dashboarddb.php",
          function: backendFunction,
          attr: JSON.stringify(payload),
        }),
      },
    });
    var obj = parseDashboardResponse(response);
    if (obj.val == 1) {
      toaster(obj.msg, "success");
      closeDashboardModalAndRefresh("#" + cfg.modalId, function () {
        reloadDashboardPage();
      });
    } else {
      toaster(obj.msg || "Erro ao guardar " + cfg.entityName + ".", "error");
    }
  } catch (error) {
    toaster(
      "Erro ao guardar " +
        cfg.entityName +
        ": " +
        (error.statusText || error.message || error),
      "error",
    );
  } finally {
    closeDashboardLoadingAlert();
  }
}

// --- Categorias (config + thin wrappers) ---

var dashboardCategoriasConfig = {
  entityName: "categoria",
  entityLabel: "Categoria",
  tableId: "dashboardCategoriasTable",
  tableBodyId: "dashboardCategoriasTableBody",
  rowSelectorClass: "dashboard-categorias-row-select",
  selectAllId: "dashboardCategoriasSelectAll",
  deleteBtnId: "dashboardCategoriasDeleteSelectedBtn",
  modalId: "dashboardCategoriaModal",
  rowIdInput: "dashboardCategoriaRowId",
  descricaoInput: "dashboardCategoriaDescricao",
  saveBtnId: "dashboardCategoriaSaveBtn",
  canEditInput: "dashboardCategoriaCanEdit",
  canDeleteInput: "dashboardCategoriaCanDelete",
  emptyMessage: "Sem categorias registadas.",
  editFnName: "editDashboardCategoria",
  addBackendFunction: "addDashboardCategoria",
  updateBackendFunction: "updateDashboardCategoria",
  deleteBackendFunction: "deleteDashboardCategoriaBulk",
  esc: 5,
};

var dashboardCategoriasRowsById = {};

var dashboardCategoriasFilterFn = null;
var dashboardCategoriasCascadeSyncing = false;

function getDashboardCategoriasTable() {
  if (
    !$.fn.DataTable ||
    !$.fn.DataTable.isDataTable("#dashboardCategoriasTable")
  ) {
    return null;
  }
  return $("#dashboardCategoriasTable").DataTable();
}

function normalizeDashboardCategoriasFilterArray(values) {
  if (!Array.isArray(values)) {
    return [];
  }

  return values
    .map(function (value) {
      return (value || "").toString().trim().toLowerCase();
    })
    .filter(function (value) {
      return value !== "";
    });
}

function getDashboardCategoriasRowsArray() {
  var rows = [];
  for (var id in dashboardCategoriasRowsById) {
    if (Object.prototype.hasOwnProperty.call(dashboardCategoriasRowsById, id)) {
      rows.push(dashboardCategoriasRowsById[id]);
    }
  }
  return rows;
}

function syncDashboardCategoriasDependentFilters(changedFilterId) {
  if (dashboardCategoriasCascadeSyncing) {
    return;
  }

  var $categoria = $("#dashboardCategoriasFilter");
  var $estadoProdutos = $("#dashboardCategoriasProdutosEstado");
  var $estadoVendas = $("#dashboardCategoriasVendasEstado");

  if (!$categoria.length || !$estadoProdutos.length || !$estadoVendas.length) {
    return;
  }

  var categoriasSel = normalizeDashboardCategoriasFilterArray($categoria.val());
  var estadoProdutosSel = ($estadoProdutos.val() || "").trim();
  var estadoVendasSel = ($estadoVendas.val() || "").trim();
  var rows = getDashboardCategoriasRowsArray();

  function rowMatchesEstadoProdutos(row, estado) {
    var totalProdutos = parseInt(row.total_produtos, 10) || 0;
    if (estado === "com") {
      return totalProdutos > 0;
    }
    if (estado === "sem") {
      return totalProdutos === 0;
    }
    return true;
  }

  function rowMatchesEstadoVendas(row, estado) {
    var totalVendas = parseInt(row.total_vendas, 10) || 0;
    if (estado === "com") {
      return totalVendas > 0;
    }
    if (estado === "sem") {
      return totalVendas === 0;
    }
    return true;
  }

  var allowedCategoriasMap = {};
  var hasComProdutos = false;
  var hasSemProdutos = false;
  var hasComVendas = false;
  var hasSemVendas = false;

  for (var i = 0; i < rows.length; i++) {
    var row = rows[i] || {};
    var categoriaRaw =
      row.descricao != null ? row.descricao.toString().trim() : "";
    var categoria = categoriaRaw.toLowerCase();

    if (
      rowMatchesEstadoProdutos(row, estadoProdutosSel) &&
      rowMatchesEstadoVendas(row, estadoVendasSel) &&
      categoriaRaw !== ""
    ) {
      allowedCategoriasMap[categoriaRaw] = true;
    }

    if (
      (categoriasSel.length === 0 || categoriasSel.indexOf(categoria) > -1) &&
      rowMatchesEstadoVendas(row, estadoVendasSel)
    ) {
      var totalProdutos = parseInt(row.total_produtos, 10) || 0;
      if (totalProdutos > 0) {
        hasComProdutos = true;
      } else {
        hasSemProdutos = true;
      }
    }

    if (
      (categoriasSel.length === 0 || categoriasSel.indexOf(categoria) > -1) &&
      rowMatchesEstadoProdutos(row, estadoProdutosSel)
    ) {
      var totalVendas = parseInt(row.total_vendas, 10) || 0;
      if (totalVendas > 0) {
        hasComVendas = true;
      } else {
        hasSemVendas = true;
      }
    }
  }

  var allowedCategorias = Object.keys(allowedCategoriasMap).sort(
    function (a, b) {
      return a.localeCompare(b, "pt", { sensitivity: "base" });
    },
  );

  function applyCategoriaOptions(options) {
    var selected = Array.isArray($categoria.val()) ? $categoria.val() : [];
    var selectedMap = {};
    for (var idx = 0; idx < selected.length; idx++) {
      selectedMap[selected[idx].toString().trim().toLowerCase()] = true;
    }

    var validSelected = [];
    $categoria.empty();

    for (var j = 0; j < options.length; j++) {
      var optionValue = options[j];
      var optionLower = optionValue.toString().trim().toLowerCase();
      var isSelected = selectedMap[optionLower] === true;

      $categoria.append(
        $("<option></option>").val(optionValue).text(optionValue),
      );

      if (isSelected) {
        validSelected.push(optionValue);
      }
    }

    $categoria.val(validSelected);
    if ($categoria.hasClass("select2-hidden-accessible")) {
      $categoria.trigger("change.select2");
    }
  }

  function applyStateOptions($select, hasCom, hasSem) {
    var current = ($select.val() || "").trim();
    var isProdutos = $select.attr("id").indexOf("Produtos") > -1;
    var options = [
      { value: "", label: "Todos" },
      { value: "com", label: isProdutos ? "Com produtos" : "Com vendas" },
      { value: "sem", label: isProdutos ? "Sem produtos" : "Sem vendas" },
    ];

    $select.empty();
    for (var k = 0; k < options.length; k++) {
      $select.append(
        $("<option></option>").val(options[k].value).text(options[k].label),
      );
    }

    var allowedValues = options.map(function (opt) {
      return opt.value;
    });
    if (allowedValues.indexOf(current) > -1) {
      $select.val(current);
    } else {
      $select.val("");
    }
  }

  dashboardCategoriasCascadeSyncing = true;

  if (changedFilterId !== "dashboardCategoriasFilter") {
    applyCategoriaOptions(allowedCategorias);
  }

  if (changedFilterId !== "dashboardCategoriasProdutosEstado") {
    applyStateOptions($estadoProdutos, hasComProdutos, hasSemProdutos);
  }

  if (changedFilterId !== "dashboardCategoriasVendasEstado") {
    applyStateOptions($estadoVendas, hasComVendas, hasSemVendas);
  }

  dashboardCategoriasCascadeSyncing = false;
}

function initializeDashboardCategoriasSelectFilters() {
  if (!$.fn.select2) {
    return;
  }

  var $categoria = $("#dashboardCategoriasFilter");
  if (!$categoria.length) {
    return;
  }

  if ($categoria.hasClass("select2-hidden-accessible")) {
    $categoria.select2("destroy");
  }

  $categoria.select2({
    placeholder: $categoria.attr("data-placeholder") || "Selecionar",
    width: "100%",
    closeOnSelect: false,
    allowClear: true,
    dropdownAutoWidth: true,
  });

  $(
    "#dashboardCategoriasFilter, #dashboardCategoriasProdutosEstado, #dashboardCategoriasVendasEstado",
  )
    .off("change.dashboardCategoriasCascade")
    .on("change.dashboardCategoriasCascade", function () {
      if (dashboardCategoriasCascadeSyncing) {
        return;
      }
      syncDashboardCategoriasDependentFilters(this.id);
    });

  syncDashboardCategoriasDependentFilters("");
}

function getDashboardCategoriasFiltersPayload() {
  var categoriasSelecionadas = $("#dashboardCategoriasFilter").val();

  return {
    categorias: Array.isArray(categoriasSelecionadas)
      ? categoriasSelecionadas
      : [],
    estadoProdutos: (
      $("#dashboardCategoriasProdutosEstado").val() || ""
    ).trim(),
    estadoVendas: ($("#dashboardCategoriasVendasEstado").val() || "").trim(),
  };
}

function applyDashboardCategoriasFilters() {
  var table = getDashboardCategoriasTable();
  if (!table) {
    return;
  }

  var filtros = getDashboardCategoriasFiltersPayload();
  var categoriasFiltro = filtros.categorias
    .map(function (item) {
      return (item || "").toString().trim().toLowerCase();
    })
    .filter(function (item) {
      return item !== "";
    });
  var estadoProdutos = filtros.estadoProdutos;
  var estadoVendas = filtros.estadoVendas;
  var canDelete = $("#dashboardCategoriaCanDelete").val() === "1";
  var colOffset = canDelete ? 1 : 0;

  if (dashboardCategoriasFilterFn !== null) {
    var idx = $.fn.dataTable.ext.search.indexOf(dashboardCategoriasFilterFn);
    if (idx > -1) {
      $.fn.dataTable.ext.search.splice(idx, 1);
    }
  }

  dashboardCategoriasFilterFn = function (settings, data, dataIndex) {
    if (
      !settings ||
      !settings.nTable ||
      settings.nTable.id !== "dashboardCategoriasTable"
    ) {
      return true;
    }

    var rowNode =
      settings && settings.aoData && settings.aoData[dataIndex]
        ? settings.aoData[dataIndex].nTr
        : null;
    var rowId = rowNode ? parseInt($(rowNode).attr("data-row-id"), 10) : NaN;
    var row = !isNaN(rowId) ? dashboardCategoriasRowsById[rowId] : null;
    var rowDescricao = data[colOffset]
      ? data[colOffset].toString().trim().toLowerCase()
      : "";
    var totalProdutos = row ? parseInt(row.total_produtos, 10) || 0 : 0;
    var totalVendas = row ? parseInt(row.total_vendas, 10) || 0 : 0;

    if (
      categoriasFiltro.length > 0 &&
      categoriasFiltro.indexOf(rowDescricao) === -1
    ) {
      return false;
    }
    if (estadoProdutos === "com" && totalProdutos < 1) {
      return false;
    }
    if (estadoProdutos === "sem" && totalProdutos > 0) {
      return false;
    }
    if (estadoVendas === "com" && totalVendas < 1) {
      return false;
    }
    if (estadoVendas === "sem" && totalVendas > 0) {
      return false;
    }

    return true;
  };

  $.fn.dataTable.ext.search.push(dashboardCategoriasFilterFn);
  table.draw();
}

function clearDashboardCategoriasFilters() {
  $("#dashboardCategoriasFilter").val([]).trigger("change");
  $("#dashboardCategoriasProdutosEstado").val("");
  $("#dashboardCategoriasVendasEstado").val("");

  var table = getDashboardCategoriasTable();
  if (!table) {
    return;
  }

  if (dashboardCategoriasFilterFn !== null) {
    var idx = $.fn.dataTable.ext.search.indexOf(dashboardCategoriasFilterFn);
    if (idx > -1) {
      $.fn.dataTable.ext.search.splice(idx, 1);
    }
    dashboardCategoriasFilterFn = null;
  }

  table.draw();
}

function renderDashboardCategoriasTable(arrayCategorias) {
  var tableBody = "";
  var canDelete = $("#dashboardCategoriaCanDelete").val() === "1";
  var canEdit = $("#dashboardCategoriaCanEdit").val() === "1";

  dashboardCategoriasRowsById = {};

  if (
    $.fn.DataTable &&
    $.fn.DataTable.isDataTable("#dashboardCategoriasTable")
  ) {
    $("#dashboardCategoriasTable").DataTable().clear().destroy();
  }

  for (var index = 0; index < arrayCategorias.length; index++) {
    var categoria = arrayCategorias[index] || {};
    var categoriaId = categoria.id != null ? categoria.id : "";
    var descricao = categoria.descricao != null ? categoria.descricao : "";
    var totalProdutos = parseInt(categoria.total_produtos, 10) || 0;
    var totalVendas = parseInt(categoria.total_vendas, 10) || 0;

    if (categoriaId !== "") {
      dashboardCategoriasRowsById[categoriaId] = categoria;
    }

    var produtosLabel =
      totalProdutos > 0 ? "Sim (" + totalProdutos + ")" : "Não (0)";
    var vendasLabel = totalVendas > 0 ? "Sim (" + totalVendas + ")" : "Não (0)";

    var actionsHtml = "";
    if (canEdit && categoriaId !== "") {
      actionsHtml +=
        "<a class='btn btn-primary btn-xs dashboard-row-edit-btn' title='Editar' onclick='editDashboardCategoria(" +
        categoriaId +
        ")'><i class='fas fa-edit'></i> Editar</a>";
    }

    tableBody +=
      "<tr data-row-id='" +
      categoriaId +
      "'>" +
      (canDelete
        ? "<td class='text-center dashboard-bulk-select-col'><input type='checkbox' class='dashboard-bulk-row-select dashboard-categorias-row-select' data-id='" +
          categoriaId +
          "'></td>"
        : "") +
      "<td>" +
      descricao +
      "</td>" +
      "<td>" +
      produtosLabel +
      "</td>" +
      "<td>" +
      vendasLabel +
      "</td>" +
      (canEdit
        ? "<td class='text-nowrap dashboard-actions-col'>" +
          actionsHtml +
          "</td>"
        : "") +
      "</tr>";
  }

  $("#dashboardCategoriasTableBody").html(tableBody);
  $("#dashboardCategoriasTable").toggleClass("dashboard-no-actions", !canEdit);
  if (
    $.fn.DataTable &&
    !$.fn.DataTable.isDataTable("#dashboardCategoriasTable")
  ) {
    createDataTable(
      "dashboardCategoriasTable",
      false,
      "",
      false,
      10,
      [],
      true,
      false,
      getDashboardResponsiveOptions(
        "dashboardCategoriasTable",
        canDelete ? [0] : [],
      ),
    );
  }

  clearDashboardTableGlobalSearch("dashboardCategoriasTable");
  bindDashboardBulkSelectionHandlers(
    "dashboardCategoriasTable",
    "dashboard-categorias-row-select",
    "dashboardCategoriasSelectAll",
    "dashboardCategoriasDeleteSelectedBtn",
  );
  initializeDashboardCategoriasSelectFilters();
  applyDashboardCategoriasFilters();
}

function openDashboardCategoriaModal() {
  openDashboardSimpleEntityModal(dashboardCategoriasConfig);
}

function editDashboardCategoria(categoriaId) {
  editDashboardSimpleEntity(
    dashboardCategoriasConfig,
    categoriaId,
    dashboardCategoriasRowsById,
  );
}

async function saveDashboardCategoria() {
  await saveDashboardSimpleEntity(dashboardCategoriasConfig);
}

function confirmDeleteSelectedDashboardCategorias() {
  modconf(
    "Tem a certeza que deseja eliminar as categorias selecionadas?",
    "deleteSelectedDashboardCategorias()",
  );
}

async function deleteSelectedDashboardCategorias() {
  await deleteDashboardSelectedRows({
    tableId: "dashboardCategoriasTable",
    rowSelectorClass: "dashboard-categorias-row-select",
    backendFunction: "deleteDashboardCategoriaBulk",
    esc: 5,
  });
}

async function downloadDashboardCategoriasPdf() {
  var filtros = getDashboardCategoriasFiltersPayload();

  showDashboardLoadingAlert(
    "A gerar PDF",
    "Aguarde, estamos a preparar o relatório...",
  );

  try {
    var response = await $.ajax({
      type: "POST",
      url: "connect.php",
      dataType: "text",
      headers: {
        Authorization: "Bearer " + md5(localStorage.getItem("sessionObject")),
      },
      data: {
        package: overal({
          origin: "module/core/php/dashboarddb.php",
          function: "exportDashboardCategoriasPdf",
          attr: JSON.stringify(filtros),
        }),
      },
    });

    var obj = parseDashboardResponse(response);
    if (obj.val == 1) {
      toaster(obj.msg, "success");
      if (obj.link) {
        window.open(obj.link, "_blank");
      }
    } else {
      toaster(obj.msg || "Erro ao gerar PDF.", "warning");
    }
  } catch (error) {
    toaster(
      "Erro ao gerar PDF: " + (error.statusText || error.message || error),
      "error",
    );
  } finally {
    closeDashboardLoadingAlert();
  }
}

// --- Cidades (config + thin wrappers) ---

var dashboardCidadesConfig = {
  entityName: "cidade",
  entityLabel: "Cidade",
  tableId: "dashboardCidadesTable",
  tableBodyId: "dashboardCidadesTableBody",
  rowSelectorClass: "dashboard-cidades-row-select",
  selectAllId: "dashboardCidadesSelectAll",
  deleteBtnId: "dashboardCidadesDeleteSelectedBtn",
  modalId: "dashboardCidadeModal",
  rowIdInput: "dashboardCidadeRowId",
  descricaoInput: "dashboardCidadeDescricao",
  saveBtnId: "dashboardCidadeSaveBtn",
  canEditInput: "dashboardCidadeCanEdit",
  canDeleteInput: "dashboardCidadeCanDelete",
  emptyMessage: "Sem cidades registadas.",
  editFnName: "editDashboardCidade",
  addBackendFunction: "addDashboardCidade",
  updateBackendFunction: "updateDashboardCidade",
  deleteBackendFunction: "deleteDashboardCidadeBulk",
  esc: 6,
};

var dashboardCidadesRowsById = {};

var dashboardCidadesFilterFn = null;
var dashboardCidadesCascadeSyncing = false;

function getDashboardCidadesTable() {
  if (
    !$.fn.DataTable ||
    !$.fn.DataTable.isDataTable("#dashboardCidadesTable")
  ) {
    return null;
  }
  return $("#dashboardCidadesTable").DataTable();
}

function normalizeDashboardCidadesFilterArray(values) {
  if (!Array.isArray(values)) {
    return [];
  }

  return values
    .map(function (value) {
      return (value || "").toString().trim().toLowerCase();
    })
    .filter(function (value) {
      return value !== "";
    });
}

function getDashboardCidadesRowsArray() {
  var rows = [];
  for (var id in dashboardCidadesRowsById) {
    if (Object.prototype.hasOwnProperty.call(dashboardCidadesRowsById, id)) {
      rows.push(dashboardCidadesRowsById[id]);
    }
  }
  return rows;
}

function syncDashboardCidadesDependentFilters(changedFilterId) {
  if (dashboardCidadesCascadeSyncing) {
    return;
  }

  var $cidade = $("#dashboardCidadesCidadeFilter");
  var $distrito = $("#dashboardCidadesDistritoFilter");
  var $concelho = $("#dashboardCidadesConcelhoFilter");
  var $produto = $("#dashboardCidadesProdutoFilter");

  if (
    !$cidade.length ||
    !$distrito.length ||
    !$concelho.length ||
    !$produto.length
  ) {
    return;
  }

  var cidadesSel = normalizeDashboardCidadesFilterArray($cidade.val());
  var distritosSel = normalizeDashboardCidadesFilterArray($distrito.val());
  var concelhosSel = normalizeDashboardCidadesFilterArray($concelho.val());
  var produtosSel = normalizeDashboardCidadesFilterArray($produto.val());
  var estadoVendasSel = $("#dashboardCidadesVendasEstado").val() || "";
  var rows = getDashboardCidadesRowsArray();

  var allowedCidadesMap = {};
  var allowedDistritosMap = {};
  var allowedConcelhosMap = {};
  var allowedProdutosMap = {};

  for (var i = 0; i < rows.length; i++) {
    var row = rows[i] || {};
    var cidadeRaw =
      row.descricao != null ? row.descricao.toString().trim() : "";
    var distritoRaw =
      row.distrito != null ? row.distrito.toString().trim() : "";
    var concelhoRaw =
      row.concelho != null ? row.concelho.toString().trim() : "";

    var cidade = cidadeRaw.toLowerCase();
    var distrito = distritoRaw.toLowerCase();
    var concelho = concelhoRaw.toLowerCase();
    var produtosTokens =
      row.produtos_tokens != null
        ? row.produtos_tokens
            .toString()
            .split("||")
            .map(function (item) {
              return (item || "").toString().trim().toLowerCase();
            })
            .filter(function (item) {
              return item !== "";
            })
        : [];
    var matchProduto =
      produtosSel.length === 0 ||
      produtosSel.some(function (produtoValue) {
        return produtosTokens.indexOf(produtoValue) > -1;
      });
    var totalVendas = parseInt(row.total_vendas, 10) || 0;
    var matchEstadoVendas =
      estadoVendasSel === "" ||
      (estadoVendasSel === "com" && totalVendas > 0) ||
      (estadoVendasSel === "sem" && totalVendas === 0);

    if (
      (distritosSel.length === 0 || distritosSel.indexOf(distrito) > -1) &&
      (concelhosSel.length === 0 || concelhosSel.indexOf(concelho) > -1) &&
      matchProduto &&
      matchEstadoVendas &&
      cidadeRaw !== ""
    ) {
      allowedCidadesMap[cidadeRaw] = true;
    }

    if (
      (cidadesSel.length === 0 || cidadesSel.indexOf(cidade) > -1) &&
      (concelhosSel.length === 0 || concelhosSel.indexOf(concelho) > -1) &&
      matchProduto &&
      matchEstadoVendas &&
      distritoRaw !== ""
    ) {
      allowedDistritosMap[distritoRaw] = true;
    }

    if (
      (cidadesSel.length === 0 || cidadesSel.indexOf(cidade) > -1) &&
      (distritosSel.length === 0 || distritosSel.indexOf(distrito) > -1) &&
      matchProduto &&
      matchEstadoVendas &&
      concelhoRaw !== ""
    ) {
      allowedConcelhosMap[concelhoRaw] = true;
    }

    if (
      (cidadesSel.length === 0 || cidadesSel.indexOf(cidade) > -1) &&
      (distritosSel.length === 0 || distritosSel.indexOf(distrito) > -1) &&
      (concelhosSel.length === 0 || concelhosSel.indexOf(concelho) > -1) &&
      matchEstadoVendas
    ) {
      for (
        var tokenIndex = 0;
        tokenIndex < produtosTokens.length;
        tokenIndex++
      ) {
        var produtoRaw = (produtosTokens[tokenIndex] || "").toString().trim();
        if (produtoRaw !== "") {
          allowedProdutosMap[produtoRaw] = true;
        }
      }
    }
  }

  var allowedCidades = Object.keys(allowedCidadesMap).sort(function (a, b) {
    return a.localeCompare(b, "pt", { sensitivity: "base" });
  });
  var allowedDistritos = Object.keys(allowedDistritosMap).sort(function (a, b) {
    return a.localeCompare(b, "pt", { sensitivity: "base" });
  });
  var allowedConcelhos = Object.keys(allowedConcelhosMap).sort(function (a, b) {
    return a.localeCompare(b, "pt", { sensitivity: "base" });
  });
  var allowedProdutos = Object.keys(allowedProdutosMap).sort(function (a, b) {
    return a.localeCompare(b, "pt", { sensitivity: "base" });
  });

  function applyOptions($select, options, keepSelectedIfMissing) {
    if (keepSelectedIfMissing === undefined) {
      keepSelectedIfMissing = true;
    }

    var selected = Array.isArray($select.val()) ? $select.val() : [];
    var selectedMap = {};
    for (var i = 0; i < selected.length; i++) {
      selectedMap[selected[i].toString().trim().toLowerCase()] = true;
    }

    var optionMap = {};
    for (var k = 0; k < options.length; k++) {
      optionMap[options[k].toString().trim().toLowerCase()] = options[k];
    }
    if (keepSelectedIfMissing) {
      for (var s = 0; s < selected.length; s++) {
        var selectedValue =
          selected[s] != null ? selected[s].toString().trim() : "";
        var selectedKey = selectedValue.toLowerCase();
        if (selectedValue !== "" && optionMap[selectedKey] == null) {
          optionMap[selectedKey] = selectedValue;
        }
      }
    }

    var mergedOptions = Object.keys(optionMap)
      .map(function (key) {
        return optionMap[key];
      })
      .sort(function (a, b) {
        return a.localeCompare(b, "pt", { sensitivity: "base" });
      });

    var validSelected = [];
    $select.empty();

    for (var j = 0; j < mergedOptions.length; j++) {
      var optionValue = mergedOptions[j];
      var optionLower = optionValue.toString().trim().toLowerCase();
      var isSelected = selectedMap[optionLower] === true;

      $select.append($("<option></option>").val(optionValue).text(optionValue));

      if (isSelected) {
        validSelected.push(optionValue);
      }
    }

    $select.val(validSelected);
    if ($select.hasClass("select2-hidden-accessible")) {
      $select.trigger("change.select2");
    }
  }

  dashboardCidadesCascadeSyncing = true;
  if (changedFilterId !== "dashboardCidadesCidadeFilter") {
    applyOptions($cidade, allowedCidades);
  }
  if (changedFilterId !== "dashboardCidadesDistritoFilter") {
    applyOptions($distrito, allowedDistritos);
  }
  if (changedFilterId !== "dashboardCidadesConcelhoFilter") {
    applyOptions($concelho, allowedConcelhos);
  }
  if (changedFilterId !== "dashboardCidadesProdutoFilter") {
    applyOptions($produto, allowedProdutos, false);
  }
  dashboardCidadesCascadeSyncing = false;
}

function initializeDashboardCidadesSelectFilters() {
  if (!$.fn.select2) {
    return;
  }

  var filterSelectors = [
    "#dashboardCidadesCidadeFilter",
    "#dashboardCidadesDistritoFilter",
    "#dashboardCidadesConcelhoFilter",
    "#dashboardCidadesProdutoFilter",
  ];

  for (var i = 0; i < filterSelectors.length; i++) {
    var selector = filterSelectors[i];
    var $filter = $(selector);
    if (!$filter.length) {
      continue;
    }

    if ($filter.hasClass("select2-hidden-accessible")) {
      $filter.select2("destroy");
    }

    $filter.select2({
      placeholder: $filter.attr("data-placeholder") || "Selecionar",
      width: "100%",
      closeOnSelect: false,
      allowClear: true,
      dropdownAutoWidth: true,
    });

    $filter
      .off("change.dashboardCidadesCascade")
      .on("change.dashboardCidadesCascade", function () {
        if (dashboardCidadesCascadeSyncing) {
          return;
        }
        syncDashboardCidadesDependentFilters(this.id);
      });
  }

  $("#dashboardCidadesVendasEstado")
    .off("change.dashboardCidadesCascade")
    .on("change.dashboardCidadesCascade", function () {
      if (dashboardCidadesCascadeSyncing) {
        return;
      }
      syncDashboardCidadesDependentFilters(this.id);
    });

  syncDashboardCidadesDependentFilters("");
}

function getDashboardCidadesFiltersPayload() {
  var cidadesSelecionadas = $("#dashboardCidadesCidadeFilter").val();
  var distritosSelecionados = $("#dashboardCidadesDistritoFilter").val();
  var concelhosSelecionados = $("#dashboardCidadesConcelhoFilter").val();
  var produtosSelecionados = $("#dashboardCidadesProdutoFilter").val();

  return {
    cidades: Array.isArray(cidadesSelecionadas) ? cidadesSelecionadas : [],
    distritos: Array.isArray(distritosSelecionados)
      ? distritosSelecionados
      : [],
    concelhos: Array.isArray(concelhosSelecionados)
      ? concelhosSelecionados
      : [],
    produtos: Array.isArray(produtosSelecionados) ? produtosSelecionados : [],
    estadoVendas: ($("#dashboardCidadesVendasEstado").val() || "").trim(),
  };
}

function applyDashboardCidadesFilters() {
  var table = getDashboardCidadesTable();
  if (!table) {
    return;
  }

  var filtros = getDashboardCidadesFiltersPayload();
  var cidadesFiltro = filtros.cidades
    .map(function (item) {
      return (item || "").toString().trim().toLowerCase();
    })
    .filter(function (item) {
      return item !== "";
    });
  var distritosFiltro = filtros.distritos
    .map(function (item) {
      return (item || "").toString().trim().toLowerCase();
    })
    .filter(function (item) {
      return item !== "";
    });
  var concelhosFiltro = filtros.concelhos
    .map(function (item) {
      return (item || "").toString().trim().toLowerCase();
    })
    .filter(function (item) {
      return item !== "";
    });
  var produtosFiltro = filtros.produtos
    .map(function (item) {
      return (item || "").toString().trim().toLowerCase();
    })
    .filter(function (item) {
      return item !== "";
    });
  var estadoVendas = filtros.estadoVendas;
  var canDelete = $("#dashboardCidadeCanDelete").val() === "1";
  var colOffset = canDelete ? 1 : 0;

  if (dashboardCidadesFilterFn !== null) {
    var idx = $.fn.dataTable.ext.search.indexOf(dashboardCidadesFilterFn);
    if (idx > -1) {
      $.fn.dataTable.ext.search.splice(idx, 1);
    }
  }

  dashboardCidadesFilterFn = function (settings, data, dataIndex) {
    if (
      !settings ||
      !settings.nTable ||
      settings.nTable.id !== "dashboardCidadesTable"
    ) {
      return true;
    }

    var rowNode =
      settings && settings.aoData && settings.aoData[dataIndex]
        ? settings.aoData[dataIndex].nTr
        : null;
    var rowId = rowNode ? parseInt($(rowNode).attr("data-row-id"), 10) : NaN;
    var row = !isNaN(rowId) ? dashboardCidadesRowsById[rowId] : null;
    var rowDescricao = data[colOffset]
      ? data[colOffset].toString().trim().toLowerCase()
      : "";
    var rowDistrito =
      row && row.distrito ? row.distrito.toString().trim().toLowerCase() : "";
    var rowConcelho =
      row && row.concelho ? row.concelho.toString().trim().toLowerCase() : "";
    var rowProdutosTokens =
      row && row.produtos_tokens
        ? row.produtos_tokens
            .toString()
            .split("||")
            .map(function (item) {
              return (item || "").toString().trim().toLowerCase();
            })
            .filter(function (item) {
              return item !== "";
            })
        : [];
    var totalVendas = row ? parseInt(row.total_vendas, 10) || 0 : 0;

    if (
      cidadesFiltro.length > 0 &&
      cidadesFiltro.indexOf(rowDescricao) === -1
    ) {
      return false;
    }
    if (
      distritosFiltro.length > 0 &&
      distritosFiltro.indexOf(rowDistrito) === -1
    ) {
      return false;
    }
    if (
      concelhosFiltro.length > 0 &&
      concelhosFiltro.indexOf(rowConcelho) === -1
    ) {
      return false;
    }
    if (produtosFiltro.length > 0) {
      var hasProduto = false;
      for (var i = 0; i < produtosFiltro.length; i++) {
        if (rowProdutosTokens.indexOf(produtosFiltro[i]) > -1) {
          hasProduto = true;
          break;
        }
      }
      if (!hasProduto) {
        return false;
      }
    }
    if (estadoVendas === "com" && totalVendas < 1) {
      return false;
    }
    if (estadoVendas === "sem" && totalVendas > 0) {
      return false;
    }

    return true;
  };

  $.fn.dataTable.ext.search.push(dashboardCidadesFilterFn);
  table.draw();
}

function clearDashboardCidadesFilters() {
  $("#dashboardCidadesCidadeFilter").val([]).trigger("change");
  $("#dashboardCidadesDistritoFilter").val([]).trigger("change");
  $("#dashboardCidadesConcelhoFilter").val([]).trigger("change");
  $("#dashboardCidadesProdutoFilter").val([]).trigger("change");
  $("#dashboardCidadesVendasEstado").val("");

  var table = getDashboardCidadesTable();
  if (!table) {
    return;
  }

  if (dashboardCidadesFilterFn !== null) {
    var idx = $.fn.dataTable.ext.search.indexOf(dashboardCidadesFilterFn);
    if (idx > -1) {
      $.fn.dataTable.ext.search.splice(idx, 1);
    }
    dashboardCidadesFilterFn = null;
  }

  table.draw();
}

function renderDashboardCidadesTable(arrayCidades) {
  var tableBody = "";
  var canDelete = $("#dashboardCidadeCanDelete").val() === "1";
  var canEdit = $("#dashboardCidadeCanEdit").val() === "1";

  dashboardCidadesRowsById = {};

  if ($.fn.DataTable && $.fn.DataTable.isDataTable("#dashboardCidadesTable")) {
    $("#dashboardCidadesTable").DataTable().clear().destroy();
  }

  for (var index = 0; index < arrayCidades.length; index++) {
    var cidade = arrayCidades[index] || {};
    var cidadeId = cidade.id != null ? cidade.id : "";
    var descricao = cidade.descricao != null ? cidade.descricao : "";
    var totalProdutos = parseInt(cidade.total_produtos, 10) || 0;
    var produtosVendidosLabel =
      totalProdutos > 0 ? "Sim (" + totalProdutos + ")" : "Sem produtos";

    if (cidadeId !== "") {
      dashboardCidadesRowsById[cidadeId] = cidade;
    }

    var actionsHtml = "";
    if (canEdit && cidadeId !== "") {
      actionsHtml +=
        "<a class='btn btn-primary btn-xs dashboard-row-edit-btn' title='Editar' onclick='editDashboardCidade(" +
        cidadeId +
        ")'><i class='fas fa-edit'></i> Editar</a>";
    }

    tableBody +=
      "<tr data-row-id='" +
      cidadeId +
      "'>" +
      (canDelete
        ? "<td class='text-center dashboard-bulk-select-col'><input type='checkbox' class='dashboard-bulk-row-select dashboard-cidades-row-select' data-id='" +
          cidadeId +
          "'></td>"
        : "") +
      "<td>" +
      descricao +
      "</td>" +
      "<td class='text-center'>" +
      produtosVendidosLabel +
      "</td>" +
      (canEdit
        ? "<td class='text-nowrap dashboard-actions-col'>" +
          actionsHtml +
          "</td>"
        : "") +
      "</tr>";
  }

  $("#dashboardCidadesTableBody").html(tableBody);
  $("#dashboardCidadesTable").toggleClass("dashboard-no-actions", !canEdit);
  if ($.fn.DataTable && !$.fn.DataTable.isDataTable("#dashboardCidadesTable")) {
    createDataTable(
      "dashboardCidadesTable",
      false,
      "",
      false,
      10,
      [],
      true,
      false,
      getDashboardResponsiveOptions(
        "dashboardCidadesTable",
        canDelete ? [0] : [],
      ),
    );
  }

  clearDashboardTableGlobalSearch("dashboardCidadesTable");
  bindDashboardBulkSelectionHandlers(
    "dashboardCidadesTable",
    "dashboard-cidades-row-select",
    "dashboardCidadesSelectAll",
    "dashboardCidadesDeleteSelectedBtn",
  );
  initializeDashboardCidadesSelectFilters();
  applyDashboardCidadesFilters();
}

function openDashboardCidadeModal() {
  openDashboardSimpleEntityModal(dashboardCidadesConfig);
}

function editDashboardCidade(cidadeId) {
  editDashboardSimpleEntity(
    dashboardCidadesConfig,
    cidadeId,
    dashboardCidadesRowsById,
  );
}

async function saveDashboardCidade() {
  await saveDashboardSimpleEntity(dashboardCidadesConfig);
}

function confirmDeleteSelectedDashboardCidades() {
  modconf(
    "Tem a certeza que deseja eliminar as cidades selecionadas?",
    "deleteSelectedDashboardCidades()",
  );
}

async function deleteSelectedDashboardCidades() {
  await deleteDashboardSelectedRows({
    tableId: "dashboardCidadesTable",
    rowSelectorClass: "dashboard-cidades-row-select",
    backendFunction: "deleteDashboardCidadeBulk",
    esc: 6,
  });
}

async function downloadDashboardCidadesPdf() {
  var filtros = getDashboardCidadesFiltersPayload();

  showDashboardLoadingAlert(
    "A gerar PDF",
    "Aguarde, estamos a preparar o relatório...",
  );

  try {
    var response = await $.ajax({
      type: "POST",
      url: "connect.php",
      dataType: "text",
      headers: {
        Authorization: "Bearer " + md5(localStorage.getItem("sessionObject")),
      },
      data: {
        package: overal({
          origin: "module/core/php/dashboarddb.php",
          function: "exportDashboardCidadesPdf",
          attr: JSON.stringify(filtros),
        }),
      },
    });

    var obj = parseDashboardResponse(response);
    if (obj.val == 1) {
      toaster(obj.msg, "success");
      if (obj.link) {
        window.open(obj.link, "_blank");
      }
    } else {
      toaster(obj.msg || "Erro ao gerar PDF.", "warning");
    }
  } catch (error) {
    toaster(
      "Erro ao gerar PDF: " + (error.statusText || error.message || error),
      "error",
    );
  } finally {
    closeDashboardLoadingAlert();
  }
}

function renderDashboardCsvTable(arrayCsv) {
  var canDelete = parseInt($("#dashboardCsvCanDelete").val(), 10) === 1;
  let tableBody = ``;

  if ($.fn.DataTable && $.fn.DataTable.isDataTable("#dashboardCsvTable")) {
    $("#dashboardCsvTable").DataTable().clear().destroy();
  }

  for (let index = 0; index < arrayCsv.length; index++) {
    const csvObj = arrayCsv[index];
    const encodedLink = encodeURIComponent((csvObj.link || "").toString());
    tableBody += `
            <tr>
                ${
                  canDelete
                    ? `<td class='text-center dashboard-bulk-select-col'><input type='checkbox' class='dashboard-bulk-row-select dashboard-csv-row-select' data-id='${index + 1}' data-file-path='${encodedLink}'></td>`
                    : ""
                }
                <td>${csvObj.nome}</td>
                <td>${csvObj.tamanho}</td>
                <td>${csvObj.data}</td>
                <td>
                  <a class='btn btn-success btn-xs dashboard-row-edit-btn dashboard-row-download-btn' href='${csvObj.link}' target='_blank' title='Download'><i class='fas fa-file-download mr-1'></i> Download</a>
                </td>
            </tr>
        `;
  }

  if (tableBody == ``) {
    tableBody = ``;
  }

  $("#dashboardCsvTableBody").html(tableBody);

  if ($.fn.DataTable && !$.fn.DataTable.isDataTable("#dashboardCsvTable")) {
    createDataTable(
      "dashboardCsvTable",
      false,
      "",
      false,
      10,
      [],
      true,
      false,
      getDashboardResponsiveOptions("dashboardCsvTable", canDelete ? [0] : []),
    );
  }
  clearDashboardTableGlobalSearch("dashboardCsvTable");

  bindDashboardBulkSelectionHandlers(
    "dashboardCsvTable",
    "dashboard-csv-row-select",
    "dashboardCsvSelectAll",
    "dashboardCsvDeleteSelectedBtn",
  );
}

async function requestDeleteDashboardCsv(filePath) {
  if (!filePath || filePath === "") {
    return {
      val: 2,
      msg: "Ficheiro inválido.",
    };
  }

  var response = await $.ajax({
    type: "POST",
    url: "connect.php",
    dataType: "text",
    headers: {
      Authorization: "Bearer " + md5(localStorage.getItem("sessionObject")),
    },
    data: {
      package: overal({
        origin: "php/checkdb.php",
        function: "deleteUploadedFile",
        attr: JSON.stringify({
          filePath: filePath,
          module: "core",
          permKey: "dashboard",
        }),
      }),
    },
  });

  return parseDashboardResponse(response);
}

function getDashboardSelectedCsvFiles() {
  var selected = [];
  getDashboardBulkRowCheckboxNodes(
    "dashboardCsvTable",
    "dashboard-csv-row-select",
    false,
  )
    .filter(":checked")
    .each(function () {
      var encodedPath = ($(this).attr("data-file-path") || "").toString();
      if (encodedPath !== "") {
        selected.push(decodeURIComponent(encodedPath));
      }
    });

  return selected;
}

function confirmDeleteSelectedDashboardCsvFiles() {
  modconf(
    "Tem a certeza que deseja eliminar os ficheiros CSV selecionados?",
    "deleteSelectedDashboardCsvFiles()",
  );
}

async function deleteSelectedDashboardCsvFiles() {
  var selectedFiles = getDashboardSelectedCsvFiles();
  if (selectedFiles.length < 1) {
    toaster("Selecione pelo menos um ficheiro para eliminar.", "warning");
    return;
  }

  showDashboardLoadingAlert(
    "A eliminar ficheiros",
    "Aguarde, estamos a processar os ficheiros selecionados...",
  );

  var deletedCount = 0;
  var failedCount = 0;
  try {
    for (var index = 0; index < selectedFiles.length; index++) {
      try {
        var obj = await requestDeleteDashboardCsv(selectedFiles[index]);
        if (obj.val == 1) {
          deletedCount++;
        } else {
          failedCount++;
        }
      } catch (error) {
        failedCount++;
      }
    }

    if (failedCount < 1) {
      toaster("Ficheiros eliminados com sucesso.", "success");
      reloadDashboardPage();
    } else if (deletedCount > 0) {
      toaster(
        "Foram eliminados " +
          deletedCount +
          " ficheiros e " +
          failedCount +
          " falharam.",
        "warning",
      );
      reloadDashboardPage();
    } else {
      toaster("Não foi possível eliminar os ficheiros selecionados.", "error");
    }
  } finally {
    closeDashboardLoadingAlert();
  }
}

var dashboardCsvPreviewRows = [];
var dashboardCsvCanImport = false;
var dashboardCsvCanDelete = false;
var dashboardCsvPreviewUploadTempPath = "";

function getDashboardCsvPreviewCounts() {
  var valid = 0;
  var invalid = 0;

  for (var i = 0; i < dashboardCsvPreviewRows.length; i++) {
    var validation = getDashboardCsvPreviewValidationState(
      dashboardCsvPreviewRows[i],
    );
    if (validation.valid) {
      valid++;
    } else {
      invalid++;
    }
  }

  return {
    total: dashboardCsvPreviewRows.length,
    valid: valid,
    invalid: invalid,
  };
}

async function discardDashboardCsvPreviewTempUpload() {
  if (!dashboardCsvPreviewUploadTempPath) {
    return;
  }

  try {
    await $.ajax({
      type: "POST",
      url: "connect.php",
      dataType: "text",
      headers: {
        Authorization: "Bearer " + md5(localStorage.getItem("sessionObject")),
      },
      data: {
        package: overal({
          origin: "module/core/php/dashboarddb.php",
          function: "discardDashboardCsvUpload",
          attr: JSON.stringify({
            uploadTempPath: dashboardCsvPreviewUploadTempPath,
          }),
        }),
      },
    });
  } catch (error) {
    toaster("Não foi possível limpar o ficheiro temporário do CSV.", "warning");
  } finally {
    dashboardCsvPreviewUploadTempPath = "";
  }
}

function getDashboardCsvPreviewValidationState(row) {
  if (typeof row._validation_valid === "boolean") {
    return {
      valid: row._validation_valid,
      msg: (
        row._validation_msg || (row._validation_valid ? "Válida" : "Inválida")
      ).toString(),
    };
  }

  return { valid: false, msg: "Não validada" };
}

function formatDashboardCsvPreviewCurrency(value) {
  var raw = (value || "").toString().trim();
  if (raw === "") {
    return "";
  }

  var normalized = raw.replace(/\s/g, "").replace(/€/g, "");
  if (normalized.indexOf(",") > -1) {
    normalized = normalized.replace(/\./g, "").replace(",", ".");
  }

  var number = parseFloat(normalized);
  if (isNaN(number)) {
    return raw;
  }

  return (
    number.toLocaleString("pt-PT", {
      minimumFractionDigits: 2,
      maximumFractionDigits: 2,
    }) + " €"
  );
}

async function validateDashboardCsvPreviewRowsWithServer(rows) {
  try {
    var response = await $.ajax({
      type: "POST",
      url: "connect.php",
      dataType: "text",
      headers: {
        Authorization: "Bearer " + md5(localStorage.getItem("sessionObject")),
      },
      data: {
        package: overal({
          origin: "module/core/php/dashboarddb.php",
          function: "validateDashboardCsvPreview",
          attr: JSON.stringify({ rows: rows || [] }),
        }),
      },
    });

    var obj = parseDashboardResponse(response);

    if (obj.val == 1 && Array.isArray(obj.rows)) {
      return obj.rows;
    }

    toaster(obj.msg || "Não foi possível validar as linhas do CSV.", "warning");
    return rows || [];
  } catch (error) {
    toaster(
      "Erro ao validar linhas do CSV: " +
        (error.statusText || error.message || error),
      "error",
    );
    return rows || [];
  }
}

function getDashboardCsvPreviewPageHtml() {
  var canDelete = dashboardCsvCanDelete === true;
  var cardClass = isDashboardCardViewport() ? " dt-card-table" : "";
  return (
    "<div id='dashboardCsvPreviewPage' class='pt-2'>" +
    "<input type='hidden' id='dashboardCsvCanImport' value='" +
    (dashboardCsvCanImport ? "1" : "0") +
    "'>" +
    "<input type='hidden' id='dashboardCsvCanDelete' value='" +
    (dashboardCsvCanDelete ? "1" : "0") +
    "'>" +
    "<div class='d-flex justify-content-between align-items-center mb-2'>" +
    "<h5 class='mb-0' style='font-weight:700; color:#111;'><i class='fas fa-table mr-1' style='color:#FF8800;'></i>Pré-visualização CSV</h5>" +
    "</div>" +
    (canDelete
      ? "<div id='dashboardCsvPreviewTopDeleteWrap' class='dashboard-csv-preview-top-delete-wrap'><button type='button' class='btn btn-danger dashboard-modal-action-btn dashboard-modal-action-btn-danger' id='dashboardCsvPreviewDeleteSelectedBtn' onclick='confirmDeleteSelectedDashboardCsvPreviewRows()' disabled><i class='fas fa-trash mr-1'></i>Eliminar</button></div>"
      : "") +
    "<div class='table-responsive'>" +
    "<table class='table table-hover table-sm" +
    cardClass +
    "' id='dashboardCsvPreviewTable' style='background: #fff; color: #111;'>" +
    "<thead>" +
    "<tr>" +
    (canDelete
      ? "<th class='text-center dashboard-bulk-select-col' style='white-space: nowrap; background: #1a1a1a; color: #fff; font-weight:700;'><label class='dashboard-bulk-select-label mb-0'><input type='checkbox' class='dashboard-bulk-select-all' id='dashboardCsvPreviewSelectAll' title='Selecionar todos'><span class='dashboard-bulk-select-text'>Sel. Todos</span></label></th>"
      : "") +
    "<th style='white-space: nowrap; background: #1a1a1a; color: #fff; font-weight:700;'><i class='fas fa-key mr-1' style='color:#FF8800;'></i>ID Venda</th>" +
    "<th style='white-space: nowrap; background: #1a1a1a; color: #fff; font-weight:700;'><i class='fas fa-clock mr-1' style='color:#FF8800;'></i>DataHora</th>" +
    "<th style='white-space: nowrap; background: #1a1a1a; color: #fff; font-weight:700;'><i class='fas fa-layer-group mr-1' style='color:#FF8800;'></i>Tipo Produto</th>" +
    "<th style='white-space: nowrap; background: #1a1a1a; color: #fff; font-weight:700;'><i class='fas fa-box mr-1' style='color:#FF8800;'></i>Descrição</th>" +
    "<th style='white-space: nowrap; background: #1a1a1a; color: #fff; font-weight:700;'><i class='fas fa-tags mr-1' style='color:#FF8800;'></i>Categoria</th>" +
    "<th style='white-space: nowrap; background: #1a1a1a; color: #fff; font-weight:700;'><i class='fas fa-euro-sign mr-1' style='color:#FF8800;'></i>Preço</th>" +
    "<th style='white-space: nowrap; background: #1a1a1a; color: #fff; font-weight:700;'><i class='fas fa-cubes mr-1' style='color:#FF8800;'></i>Qtd</th>" +
    "<th style='white-space: nowrap; background: #1a1a1a; color: #fff; font-weight:700;'><i class='fas fa-calculator mr-1' style='color:#FF8800;'></i>Receita</th>" +
    "<th style='white-space: nowrap; background: #1a1a1a; color: #fff; font-weight:700;'><i class='fas fa-store mr-1' style='color:#FF8800;'></i>Canal</th>" +
    "<th style='white-space: nowrap; background: #1a1a1a; color: #fff; font-weight:700;'><i class='fas fa-city mr-1' style='color:#FF8800;'></i>Cidade</th>" +
    "<th style='white-space: nowrap; background: #1a1a1a; color: #fff; font-weight:700;'><i class='fas fa-check-circle mr-1' style='color:#FF8800;'></i>Estado</th>" +
    "<th style='white-space: nowrap; background: #1a1a1a; color: #fff; font-weight:700;'><i class='fas fa-cogs mr-1' style='color:#FF8800;'></i>Ações</th>" +
    "</tr>" +
    "</thead>" +
    "<tbody id='dashboardCsvPreviewTableBody'></tbody>" +
    "</table>" +
    "</div>" +
    "<div class='d-flex justify-content-end mt-3 dashboard-csv-preview-bottom-actions'>" +
    "<button type='button' class='btn btn-secondary dashboard-modal-action-btn dashboard-modal-action-btn-secondary mr-2' onclick='cancelDashboardCsvPreviewPage()'><i class='fas fa-times mr-1'></i>Cancelar</button>" +
    (canDelete
      ? "<button type='button' class='btn btn-danger dashboard-modal-action-btn dashboard-modal-action-btn-danger dashboard-csv-preview-bottom-delete mr-2' id='dashboardCsvPreviewDeleteSelectedBtnBottom' onclick='confirmDeleteSelectedDashboardCsvPreviewRows()' disabled><i class='fas fa-trash mr-1'></i>Eliminar</button>"
      : "") +
    "<button type='button' class='btn btn-success dashboard-modal-action-btn dashboard-modal-action-btn-success' id='dashboardCsvCommitBtn' onclick='confirmCommitDashboardCsvPreview()'><i class='fas fa-check mr-1'></i>Confirmar inserção</button>" +
    "</div>" +
    "<div class='modal fade' id='dashboardCsvRowModal' tabindex='-1' role='dialog' aria-hidden='true'>" +
    "<div class='modal-dialog modal-lg' role='document'>" +
    "<div class='modal-content'>" +
    "<div class='modal-header'>" +
    "<h5 class='modal-title'>Editar linha CSV</h5>" +
    "<button type='button' class='close' data-dismiss='modal' aria-label='Close'><span aria-hidden='true'>&times;</span></button>" +
    "</div>" +
    "<div class='modal-body'>" +
    "<div class='row'>" +
    "<div class='col-md-6 mb-2'><input type='hidden' id='dashboardCsvEditIndex' value=''><label class='form-label'>ID Venda *</label><input type='text' class='form-control' id='dashboardCsvEditIdVenda' placeholder='ID da venda'></div>" +
    "<div class='col-md-6 mb-2'><label class='form-label'>DataHora (dd/mm/yyyy hh:mm) *</label><input type='text' class='form-control' id='dashboardCsvEditDataHora' placeholder='dd/mm/yyyy hh:mm'></div>" +
    "<div class='col-md-6 mb-2'><label class='form-label'>Tipo Produto *</label><input type='text' class='form-control' id='dashboardCsvEditTipoProduto' placeholder='Tipo de produto'></div>" +
    "<div class='col-md-6 mb-2'><label class='form-label'>Descrição Artigo *</label><input type='text' class='form-control' id='dashboardCsvEditDescricao' placeholder='Descrição do artigo'></div>" +
    "<div class='col-md-6 mb-2'><label class='form-label'>Categoria *</label><input type='text' class='form-control' id='dashboardCsvEditCategoria' placeholder='Categoria'></div>" +
    "<div class='col-md-6 mb-2'><label class='form-label'>Canal Venda *</label><input type='text' class='form-control' id='dashboardCsvEditCanal' placeholder='Canal de venda'></div>" +
    "<div class='col-md-6 mb-2'><label class='form-label'>Cidade *</label><input type='text' class='form-control' id='dashboardCsvEditCidade' placeholder='Cidade'></div>" +
    "<div class='col-md-3 mb-2'><label class='form-label'>Preço Unitário *</label><input type='text' class='form-control' id='dashboardCsvEditPreco' placeholder='0,00'></div>" +
    "<div class='col-md-3 mb-2'><label class='form-label'>Quantidade *</label><input type='text' class='form-control' id='dashboardCsvEditQuantidade' placeholder='0'></div>" +
    "</div>" +
    "</div>" +
    "<div class='modal-footer'>" +
    "<button type='button' class='btn btn-secondary' data-dismiss='modal'><i class='fas fa-times mr-1'></i>Cancelar</button>" +
    "<button type='button' class='btn btn-success' id='dashboardCsvRowSaveBtn' onclick='saveDashboardCsvPreviewRow()'><i class='fas fa-check mr-1'></i>Atualizar linha</button>" +
    "</div>" +
    "</div>" +
    "</div>" +
    "</div>" +
    "</div>"
  );
}

/* ── CSV Preview: resize handler for card-mode toggle ── */
var _dashboardCsvPreviewResizeTimer = null;
var _dashboardCsvPreviewWasCard = null;
var _dashboardCsvPreviewRenderGen = 0;

function _dashboardCsvPreviewResizeHandler() {
  if (!$("#dashboardCsvPreviewPage").length) return;
  var isCard = isDashboardCardViewport();
  if (_dashboardCsvPreviewWasCard === isCard) return;
  _dashboardCsvPreviewWasCard = isCard;
  renderDashboardCsvPreviewTable();
}

function _startDashboardCsvPreviewResizeWatch() {
  _dashboardCsvPreviewWasCard = isDashboardCardViewport();
  $(window)
    .off("resize.dashboardCsvPreview")
    .on("resize.dashboardCsvPreview", function () {
      clearTimeout(_dashboardCsvPreviewResizeTimer);
      _dashboardCsvPreviewResizeTimer = setTimeout(
        _dashboardCsvPreviewResizeHandler,
        300,
      );
    });
}

function _stopDashboardCsvPreviewResizeWatch() {
  $(window).off("resize.dashboardCsvPreview");
  clearTimeout(_dashboardCsvPreviewResizeTimer);
  _dashboardCsvPreviewWasCard = null;
}

function openDashboardCsvPreviewPage() {
  $("#content2").html(getDashboardCsvPreviewPageHtml());
  _startDashboardCsvPreviewResizeWatch();
  renderDashboardCsvPreviewTable();
}

async function cancelDashboardCsvPreviewPage() {
  await discardDashboardCsvPreviewTempUpload();
  _stopDashboardCsvPreviewResizeWatch();
  dashboardCsvPreviewRows = [];
  reworkbar(2);
}

function renderDashboardCsvPreviewTable() {
  var tableBody = "";
  var validRows = 0;
  var canDelete = dashboardCsvCanDelete === true;

  for (var index = 0; index < dashboardCsvPreviewRows.length; index++) {
    var row = dashboardCsvPreviewRows[index];
    var validation = getDashboardCsvPreviewValidationState(row);
    if (validation.valid) {
      validRows++;
    }

    var badgeClass = validation.valid ? "badge-success" : "badge-danger";
    var badgeStyle = validation.valid
      ? "background-color:#28a745;color:#fff;"
      : "background-color:#dc3545;color:#fff;";
    var validationText = validation.msg;
    tableBody +=
      "<tr>" +
      (canDelete
        ? "<td class='text-center dashboard-bulk-select-col'><input type='checkbox' class='dashboard-bulk-row-select dashboard-csv-preview-row-select' data-id='" +
          (index + 1) +
          "' data-index='" +
          index +
          "'></td>"
        : "") +
      "<td>" +
      (row.id_venda || "") +
      "</td>" +
      "<td>" +
      (row.datahora || "") +
      "</td>" +
      "<td>" +
      (row.tipo_produto || "") +
      "</td>" +
      "<td>" +
      (row.descricao_artigo || "") +
      "</td>" +
      "<td>" +
      (row.categoria || "") +
      "</td>" +
      "<td>" +
      (row.preco_unitario || "") +
      "</td>" +
      "<td>" +
      (row.quantidade || "") +
      "</td>" +
      "<td>" +
      formatDashboardCsvPreviewCurrency(row.receita_calculada || "") +
      "</td>" +
      "<td>" +
      (row.canal_venda || "") +
      "</td>" +
      "<td>" +
      (row.cidade || "") +
      "</td>" +
      "<td><span class='badge " +
      badgeClass +
      " border-0' style='cursor: default;" +
      badgeStyle +
      "'>" +
      validationText +
      "</span></td>" +
      "<td>" +
      "<a class='btn btn-primary btn-xs dashboard-row-edit-btn' title='Editar' onclick='openDashboardCsvRowModal(\"edit\", " +
      index +
      ")'><i class='fas fa-edit'></i> Editar</a>" +
      "</td>" +
      "</tr>";
  }

  if (tableBody === "") {
    tableBody =
      "<tr><td class='text-center text-muted' colspan='" +
      (canDelete ? "13" : "12") +
      "'>Sem linhas para tratar.</td></tr>";
  }

  if (
    $.fn.DataTable &&
    $.fn.DataTable.isDataTable("#dashboardCsvPreviewTable")
  ) {
    $("#dashboardCsvPreviewTable").DataTable().destroy();
  }

  $("#dashboardCsvPreviewTableBody").html(tableBody);
  $("#dashboardCsvCommitBtn").prop("disabled", validRows < 1);

  var isCard = isDashboardCardViewport();
  var renderGen = ++_dashboardCsvPreviewRenderGen;
  /* Pre-add card class so CSS card layout applies immediately */
  if (isCard) {
    $("#dashboardCsvPreviewTable").addClass("dt-card-table");
  } else {
    $("#dashboardCsvPreviewTable").removeClass("dt-card-table");
  }

  if ($.fn.DataTable) {
    createDataTable(
      "dashboardCsvPreviewTable",
      false,
      "",
      false,
      4,
      [],
      true,
      false,
      getDashboardResponsiveOptions(
        "dashboardCsvPreviewTable",
        canDelete ? [0] : [],
      ),
    ).then(function (dataTable) {
      /* Skip if a newer render has superseded this one */
      if (renderGen !== _dashboardCsvPreviewRenderGen) return;

      /* ── Safety-net: enforce card mode if createDataTable missed it ── */
      var isCardNow = isDashboardCardViewport();
      var $tbl = $("#dashboardCsvPreviewTable");
      var hasCard = $tbl.hasClass("dt-card-table");

      if (isCardNow && !hasCard) {
        $tbl.addClass("dt-card-table");
      } else if (!isCardNow && hasCard) {
        $tbl.removeClass("dt-card-table");
      }

      if (isCardNow) {
        /* Force card page-length */
        if (dataTable && dataTable.page && dataTable.page.len) {
          if (dataTable.page.len() !== 4) {
            dataTable.page.len(4).draw(false);
          }
        }
        /* Hide length dropdown in card mode */
        $("#dashboardCsvPreviewTable_wrapper")
          .find(".dt-length, .dataTables_length")
          .hide();
      } else {
        /* Show length dropdown in desktop mode */
        $("#dashboardCsvPreviewTable_wrapper")
          .find(".dt-length, .dataTables_length")
          .show();
      }

      /* Always apply card labels (data-label attrs) for ::before CSS */
      applyDashboardCardLabels("dashboardCsvPreviewTable");
      bindDashboardCsvPreviewSelectionHandlers();
    });
  } else {
    if (isCard) {
      $("#dashboardCsvPreviewTable").addClass("dt-card-table");
    } else {
      $("#dashboardCsvPreviewTable").removeClass("dt-card-table");
    }
    applyDashboardCardLabels("dashboardCsvPreviewTable");
    bindDashboardCsvPreviewSelectionHandlers();
  }
}

function updateDashboardCsvPreviewDeleteButtonState() {
  var $deleteBtn = $(
    "#dashboardCsvPreviewDeleteSelectedBtn, #dashboardCsvPreviewDeleteSelectedBtnBottom",
  );
  if (!$deleteBtn.length) {
    return;
  }

  syncDashboardCardSelectedState(
    "dashboardCsvPreviewTable",
    "dashboard-csv-preview-row-select",
  );

  var $allRows = getDashboardBulkRowCheckboxNodes(
    "dashboardCsvPreviewTable",
    "dashboard-csv-preview-row-select",
    false,
  );
  var totalCount = $allRows.length;
  var checkedCount = $allRows.filter(":checked").length;
  $deleteBtn.prop("disabled", checkedCount < 1);
  var nextChecked = false;
  var nextIndeterminate = false;
  var $selectAll = $("#dashboardCsvPreviewSelectAll");
  updateDashboardBulkSelectAllLabel(
    "dashboardCsvPreviewTable",
    "dashboard-csv-preview-row-select",
    "dashboardCsvPreviewSelectAll",
  );

  if ($selectAll.length) {
    if (totalCount < 1) {
      if ($selectAll.prop("checked") !== false) {
        $selectAll.prop("checked", false);
      }
      if ($selectAll.prop("indeterminate") !== false) {
        $selectAll.prop("indeterminate", false);
      }
      return;
    }

    nextChecked = checkedCount === totalCount;
    nextIndeterminate = checkedCount > 0 && checkedCount < totalCount;

    if ($selectAll.prop("checked") !== nextChecked) {
      $selectAll.prop("checked", nextChecked);
    }
    if ($selectAll.prop("indeterminate") !== nextIndeterminate) {
      $selectAll.prop("indeterminate", nextIndeterminate);
    }
  }
}

function bindDashboardCsvPreviewSelectionHandlers() {
  bindDashboardCardTapSelection(
    "dashboardCsvPreviewTable",
    "dashboard-csv-preview-row-select",
    "dashboardCsvPreviewSelectAll",
    "dashboardCsvPreviewDeleteSelectedBtn",
    "dashboardCardTap_dashboardCsvPreviewTable",
  );

  $(document)
    .off("change.dashboardCsvPreviewSelectAll", "#dashboardCsvPreviewSelectAll")
    .on(
      "change.dashboardCsvPreviewSelectAll",
      "#dashboardCsvPreviewSelectAll",
      function () {
        var checked = $(this).is(":checked");
        if ($(this).prop("indeterminate") !== false) {
          $(this).prop("indeterminate", false);
        }
        getDashboardBulkRowCheckboxNodes(
          "dashboardCsvPreviewTable",
          "dashboard-csv-preview-row-select",
          false,
        ).prop("checked", checked);
        $(
          "#dashboardCsvPreviewTable tbody .dashboard-csv-preview-row-select",
        ).prop("checked", checked);
        updateDashboardCsvPreviewDeleteButtonState();
      },
    );

  $(document)
    .off(
      "change.dashboardCsvPreviewRow",
      "#dashboardCsvPreviewTable tbody .dashboard-csv-preview-row-select",
    )
    .on(
      "change.dashboardCsvPreviewRow",
      "#dashboardCsvPreviewTable tbody .dashboard-csv-preview-row-select",
      function () {
        updateDashboardCsvPreviewDeleteButtonState();
      },
    );

  $("#dashboardCsvPreviewTable")
    .off("draw.dt.dashboardCsvPreview")
    .on("draw.dt.dashboardCsvPreview", function () {
      updateDashboardCsvPreviewDeleteButtonState();
    });

  updateDashboardCsvPreviewDeleteButtonState();
}

function calcDashboardCsvReceita(precoStr, quantStr) {
  var preco = parseFloat((precoStr || "0").replace(",", ".")) || 0;
  var quant = parseFloat((quantStr || "0").replace(",", ".")) || 0;
  var result = preco * quant;
  return result.toFixed(2).replace(".", ",");
}

function openDashboardCsvRowModal(mode, rowIndex) {
  var index = parseInt(rowIndex, 10);
  if (isNaN(index) || index < 0 || index >= dashboardCsvPreviewRows.length) {
    toaster("Linha inválida para edição.", "warning");
    return;
  }

  var row = dashboardCsvPreviewRows[index];
  var $modal = $("#dashboardCsvRowModal").last();

  $modal.find("#dashboardCsvEditIndex").val(index);
  $modal.find("#dashboardCsvEditIdVenda").val((row && row.id_venda) || "");
  $modal.find("#dashboardCsvEditDataHora").val((row && row.datahora) || "");
  $modal
    .find("#dashboardCsvEditTipoProduto")
    .val((row && row.tipo_produto) || "");
  $modal
    .find("#dashboardCsvEditDescricao")
    .val((row && row.descricao_artigo) || "");
  $modal.find("#dashboardCsvEditCategoria").val((row && row.categoria) || "");
  $modal.find("#dashboardCsvEditPreco").val((row && row.preco_unitario) || "");
  $modal.find("#dashboardCsvEditQuantidade").val((row && row.quantidade) || "");
  $modal.find("#dashboardCsvEditCanal").val((row && row.canal_venda) || "");
  $modal.find("#dashboardCsvEditCidade").val((row && row.cidade) || "");

  $modal.find(".modal-title").text("Editar linha CSV");
  $modal
    .find("#dashboardCsvRowSaveBtn")
    .html("<i class='fas fa-check mr-1'></i>Atualizar linha");

  $modal.modal("show");
}

function getDashboardSelectedCsvPreviewIndexes() {
  var selected = [];
  $("#dashboardCsvPreviewTable tbody .dashboard-csv-preview-row-select")
    .filter(":checked")
    .each(function () {
      var rowIndex = parseInt($(this).attr("data-index"), 10);
      if (!isNaN(rowIndex) && rowIndex >= 0) {
        selected.push(rowIndex);
      }
    });

  return selected;
}

function confirmDeleteSelectedDashboardCsvPreviewRows() {
  modconf(
    "Tem a certeza que deseja eliminar as linhas CSV selecionadas?",
    "deleteSelectedDashboardCsvPreviewRows()",
  );
}

async function deleteSelectedDashboardCsvPreviewRows() {
  if (!dashboardCsvCanDelete) {
    toaster("Sem permissão para eliminar linhas CSV.", "warning");
    return;
  }

  var selectedIndexes = getDashboardSelectedCsvPreviewIndexes();
  if (selectedIndexes.length < 1) {
    toaster("Selecione pelo menos uma linha para eliminar.", "warning");
    return;
  }

  showDashboardLoadingAlert(
    "A eliminar linhas",
    "Aguarde, estamos a atualizar a pré-visualização...",
  );

  try {
    selectedIndexes.sort(function (a, b) {
      return b - a;
    });

    for (var i = 0; i < selectedIndexes.length; i++) {
      var idx = selectedIndexes[i];
      if (idx >= 0 && idx < dashboardCsvPreviewRows.length) {
        dashboardCsvPreviewRows.splice(idx, 1);
      }
    }

    dashboardCsvPreviewRows = await validateDashboardCsvPreviewRowsWithServer(
      dashboardCsvPreviewRows,
    );
    renderDashboardCsvPreviewTable();
  } finally {
    closeDashboardLoadingAlert();
  }
}

async function saveDashboardCsvPreviewRow() {
  var $modal = $("#dashboardCsvRowModal:visible").last();
  if (!$modal.length) {
    $modal = $("#dashboardCsvRowModal").last();
  }

  var index = parseInt($modal.find("#dashboardCsvEditIndex").val(), 10);
  if (isNaN(index) || index < 0 || index >= dashboardCsvPreviewRows.length) {
    toaster("Linha inválida para guardar.", "warning");
    return;
  }

  var payload = {
    id_venda: ($modal.find("#dashboardCsvEditIdVenda").val() || "").trim(),
    datahora: ($modal.find("#dashboardCsvEditDataHora").val() || "").trim(),
    tipo_produto: (
      $modal.find("#dashboardCsvEditTipoProduto").val() || ""
    ).trim(),
    descricao_artigo: (
      $modal.find("#dashboardCsvEditDescricao").val() || ""
    ).trim(),
    categoria: ($modal.find("#dashboardCsvEditCategoria").val() || "").trim(),
    preco_unitario: ($modal.find("#dashboardCsvEditPreco").val() || "").trim(),
    quantidade: ($modal.find("#dashboardCsvEditQuantidade").val() || "").trim(),
    receita_calculada: calcDashboardCsvReceita(
      ($modal.find("#dashboardCsvEditPreco").val() || "").trim(),
      ($modal.find("#dashboardCsvEditQuantidade").val() || "").trim(),
    ),
    canal_venda: ($modal.find("#dashboardCsvEditCanal").val() || "").trim(),
    cidade: ($modal.find("#dashboardCsvEditCidade").val() || "").trim(),
  };

  dashboardCsvPreviewRows[index].id_venda = payload.id_venda;
  dashboardCsvPreviewRows[index].datahora = payload.datahora;
  dashboardCsvPreviewRows[index].tipo_produto = payload.tipo_produto;
  dashboardCsvPreviewRows[index].descricao_artigo = payload.descricao_artigo;
  dashboardCsvPreviewRows[index].categoria = payload.categoria;
  dashboardCsvPreviewRows[index].preco_unitario = payload.preco_unitario;
  dashboardCsvPreviewRows[index].quantidade = payload.quantidade;
  dashboardCsvPreviewRows[index].receita_calculada = payload.receita_calculada;
  dashboardCsvPreviewRows[index].canal_venda = payload.canal_venda;
  dashboardCsvPreviewRows[index].cidade = payload.cidade;

  showDashboardLoadingAlert(
    "A atualizar linha",
    "Aguarde, estamos a validar e atualizar os dados...",
  );

  try {
    dashboardCsvPreviewRows = await validateDashboardCsvPreviewRowsWithServer(
      dashboardCsvPreviewRows,
    );

    $modal.modal("hide");
    renderDashboardCsvPreviewTable();
    toaster("Linha atualizada em memória.", "success");
  } finally {
    closeDashboardLoadingAlert();
  }
}

async function deleteDashboardCsvPreviewRow(rowIndex) {
  var index = parseInt(rowIndex, 10);
  if (isNaN(index) || index < 0 || index >= dashboardCsvPreviewRows.length) {
    toaster("Linha inválida para eliminar.", "warning");
    return;
  }

  dashboardCsvPreviewRows.splice(index, 1);
  dashboardCsvPreviewRows = await validateDashboardCsvPreviewRowsWithServer(
    dashboardCsvPreviewRows,
  );
  renderDashboardCsvPreviewTable();
}

function confirmCommitDashboardCsvPreview() {
  var counts = getDashboardCsvPreviewCounts();
  modconf(
    "Tem a certeza que deseja confirmar a inserção? Linhas válidas: " +
      counts.valid +
      " de " +
      counts.total +
      (counts.invalid > 0 ? " (inválidas: " + counts.invalid + ")" : ""),
    "commitDashboardCsvPreview()",
  );
}

async function commitDashboardCsvPreview() {
  var canImport = parseInt($("#dashboardCsvCanImport").val(), 10) === 1;
  if (!canImport) {
    toaster("Sem permissão para importar dados CSV.", "warning");
    return;
  }

  var validRows = [];
  for (var i = 0; i < dashboardCsvPreviewRows.length; i++) {
    var validation = getDashboardCsvPreviewValidationState(
      dashboardCsvPreviewRows[i],
    );
    if (validation.valid) {
      validRows.push(dashboardCsvPreviewRows[i]);
    }
  }

  if (validRows.length < 1) {
    toaster("Não existem linhas válidas para inserir.", "warning");
    return;
  }

  showDashboardLoadingAlert(
    "A inserir dados",
    "Aguarde, estamos a confirmar a inserção na base de dados...",
  );

  try {
    var response = await $.ajax({
      type: "POST",
      url: "connect.php",
      dataType: "text",
      headers: {
        Authorization: "Bearer " + md5(localStorage.getItem("sessionObject")),
      },
      data: {
        package: overal({
          origin: "module/core/php/dashboarddb.php",
          function: "commitDashboardCsvPreview",
          attr: JSON.stringify({
            rows: validRows,
            uploadTempPath: dashboardCsvPreviewUploadTempPath,
          }),
        }),
      },
    });
    var obj = parseDashboardResponse(response);
    if (obj.val == 1) {
      toaster(
        (obj.msg || "Importação concluída.") +
          " Inseridos: " +
          (obj.importedRows || 0) +
          " | Ignorados: " +
          (obj.skippedRows || 0),
        "success",
      );
      dashboardCsvPreviewUploadTempPath = "";
      dashboardCsvPreviewRows = [];
      reloadDashboardPage();
    } else {
      toaster(obj.msg || "Erro ao confirmar importação.", "error");
    }
  } catch (error) {
    toaster(
      "Erro ao confirmar importação: " +
        (error.statusText || error.message || error),
      "error",
    );
  } finally {
    closeDashboardLoadingAlert();
  }
}

async function uploadDashboardCsv() {
  await discardDashboardCsvPreviewTempUpload();

  const input = document.getElementById("dashboardCsvFiles");
  if (!input || !input.files || input.files.length === 0) {
    toaster("Selecione um ficheiro CSV.", "warning");
    return;
  }

  if (input.files.length !== 1) {
    toaster("É permitido enviar apenas 1 ficheiro por vez.", "warning");
    return;
  }

  const file = input.files[0];
  const fileName = (file.name || "").toLowerCase();
  if (!fileName.endsWith(".csv")) {
    toaster("Apenas ficheiros CSV são permitidos.", "warning");
    return;
  }

  showDashboardLoadingAlert(
    "A processar CSV",
    "Aguarde, a carregar e validar o ficheiro...",
  );

  try {
    var formData = new FormData();
    formData.append(
      "package",
      overal({
        origin: "module/core/php/dashboarddb.php",
        function: "uploadDashboardCsv",
        attr: JSON.stringify({}),
      }),
    );
    formData.append("files[]", file);

    var response = await $.ajax({
      type: "POST",
      url: "connect.php",
      dataType: "text",
      headers: {
        Authorization: "Bearer " + md5(localStorage.getItem("sessionObject")),
      },
      data: formData,
      processData: false,
      contentType: false,
    });

    var obj = parseDashboardResponse(response);
    if (obj.val != 1) {
      toaster(obj.msg || "Não foi possível carregar o ficheiro CSV.", "error");
      input.value = "";
      return;
    }

    dashboardCsvPreviewUploadTempPath = (obj.uploadTempPath || "").toString();

    dashboardCsvPreviewRows = Array.isArray(obj.rows) ? obj.rows : [];
    if (dashboardCsvPreviewRows.length < 1) {
      await discardDashboardCsvPreviewTempUpload();
      toaster(
        obj.msg || "O ficheiro não contém linhas para importar.",
        "warning",
      );
      input.value = "";
      reworkbar(2);
      return;
    }

    dashboardCsvPreviewRows = await validateDashboardCsvPreviewRowsWithServer(
      dashboardCsvPreviewRows,
    );

    dashboardCsvCanImport =
      parseInt($("#dashboardCsvCanImport").val(), 10) === 1;
    dashboardCsvCanDelete =
      parseInt($("#dashboardCsvCanDelete").val(), 10) === 1;

    if (Array.isArray(obj.array)) {
      renderDashboardCsvTable(obj.array);
    }

    openDashboardCsvPreviewPage();
    toaster(
      obj.msg ||
        "Ficheiro CSV carregado para tratamento. A inserção só acontece após confirmação.",
      "success",
    );
    input.value = "";
  } catch (error) {
    moderr("Request failed: " + (error.statusText || error.message || error));
  } finally {
    closeDashboardLoadingAlert();
  }
}
