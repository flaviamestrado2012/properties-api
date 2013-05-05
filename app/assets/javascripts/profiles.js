
function addPropertyRange() { 

  var insertedValueExact = $('#propertyValueExact').val(); // don't forget to validate value according to the propertyType
  var insertedValueMin = $('#propertyValueMin').val();
  var insertedValueMax = $('#propertyValueMax').val();
  
  var selectedPropertyId = $('#propertyRangeToAdd').val();
  var properties = $('#addedPropertyRangesTable').data('properties');

  for (var i = 0; i < properties.length; i++) {
    if (selectedPropertyId == properties[i].id) {
      var selectedPropertyName = properties[i].name;
      var selectedPropertyType = properties[i].value_type;
      break;
    }
  }

 
/* // Validate inserted value according to selected property type
  if (selectedPropertyType === 'Numeric') {
    if (!validateNumber(insertedValue)) {
      $('#invalidValueError').show();
      return;
    } 
  }
  */ 


  $('#invalidValueError').hide();
    
  // Clone template and fill child elements
  property = $('#propertyRangeLineTemplate').clone().removeClass('template');
  property.attr('id', property.attr('id') + selectedPropertyId);

  var hiddenInputs = $('input', property); 
  hiddenInputs.eq(0).attr('name', 'insertedProperties' + '[' + selectedPropertyId + ']' + '[exact]');
  hiddenInputs.eq(0).val(insertedValueExact);

  hiddenInputs.eq(1).attr('name', 'insertedProperties' + '[' + selectedPropertyId + ']' + '[min]');
  hiddenInputs.eq(1).val(insertedValueMin);

  hiddenInputs.eq(2).attr('name', 'insertedProperties' + '[' + selectedPropertyId + ']' + '[max]');
  hiddenInputs.eq(2).val(insertedValueMax);

  var cells = $('td', property);
  cells.eq(0).text(selectedPropertyName);
  cells.eq(1).text(insertedValueExact);
  cells.eq(2).text(insertedValueMin);
  cells.eq(3).text(insertedValueMax);
  cells.eq(4).html(cells.eq(4).html().replace('#property_id#', selectedPropertyId));

  removeAvailableProperty(selectedPropertyId)
  $('#addedPropertyRangesTable').append(property);
  $('#propertyValueExact').val('');
  $('#propertyValueMin').val('');
  $('#propertyValueMax').val('');

  removeAvailablePropertyRange(selectedPropertyId)
  $('#addedPropertyRangesTable').append(property);
}


function addAvailablePropertyRange(id, name) {
  $("#propertyRangeToAdd").append('<option value="' + id + '">' + name + '</option>');
  toggleAvailablePropertyRangesSelect();
}

function removeAvailablePropertyRange(id) {
  $("#propertyRangeToAdd option[value='" + id + "']").remove();
  toggleAvailablePropertyRangesSelect();
}

function toggleAvailablePropertyRangesSelect() {
  if ($('#propertyRangeToAdd option').size() > 0) {
    $('#availablePropertyRangesContainer').show();
  } else {
    $('#availablePropertyRangesContainer').hide();
  }
}

function removePropertyRange(confirmMessage, id) {
  if (confirm(confirmMessage)) {
    var properties = $('#addedPropertyRangesTable').data('properties');
    
    for (var i = 0; i < properties.length; i++) {
      if (id == properties[i].id) {
        var selectedPropertyName = properties[i].name;
        break;
      }
    }

    $('#propertyRangeLineTemplate' + id).remove();
    addAvailablePropertyRange(id, selectedPropertyName);
  }
}