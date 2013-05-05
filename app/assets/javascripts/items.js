function addProperty() {  
  var insertedValue = $('#propertyValue').val(); // don't forget to validate value according to the propertyType
  
  var selectedPropertyId = $('#propertyToAdd').val();
  var properties = $('#addedPropertiesTable').data('properties');
  
  for (var i = 0; i < properties.length; i++) {
    if (selectedPropertyId == properties[i].id) {
      var selectedPropertyName = properties[i].name;
      var selectedPropertyType = properties[i].value_type;
      break;
    }
  }
  
  // Validate inserted value according to selected property type
  if (selectedPropertyType === 'Numeric') {
    if (!validateNumber(insertedValue)) {
      $('#invalidValueError').show();
      return;
    } 
  } 

  $('#invalidValueError').hide();
    
  // Clone template and fill child elements
  property = $('#propertyLineTemplate').clone().removeClass('template');
  property.attr('id', property.attr('id') + selectedPropertyId);

  var hiddenInput = $('input', property); 
  hiddenInput.attr('name', 'insertedProperties' + '[' + selectedPropertyId + ']');
  hiddenInput.val(insertedValue);

  var cells = $('td', property);
  cells.eq(0).text(selectedPropertyName);
  cells.eq(1).text(insertedValue);
  cells.eq(2).html(cells.eq(2).html().replace('#property_id#', selectedPropertyId));

  removeAvailableProperty(selectedPropertyId)
  $('#addedPropertiesTable').append(property);
  $('#propertyValue').val('');
}

function addCategory() {  
   
  var selectedCategoryId = $('#categoryToAdd').val();
  var categories = $('#addedCategoriesTable').data('categories');
  
  for (var i = 0; i < categories.length; i++) {
    if (selectedCategoryId == categories[i].id) {
      var selectedCategoryName = categories[i].name;
      break;
    }
  }
   
  // Clone template and fill child elements
  category = $('#categoryLineTemplate').clone().removeClass('template');
  category.attr('id', category.attr('id') + selectedCategoryId);

  var hiddenInput = $('input', category); 
  hiddenInput.attr('name', 'insertedCategories[]');
  hiddenInput.val(selectedCategoryId);

  var cells = $('td', category);
  cells.eq(0).text(selectedCategoryName);
  cells.eq(1).html(cells.eq(1).html().replace('#category_id#', selectedCategoryId));

  removeAvailableCategory(selectedCategoryId)
  $('#addedCategoriesTable').append(category);
}

function addAvailableProperty(id, name) {
  $("#propertyToAdd").append('<option value="' + id + '">' + name + '</option>');
  toggleAvailablePropertiesSelect();
}

function removeAvailableProperty(id) {
  $("#propertyToAdd option[value='" + id + "']").remove();
  toggleAvailablePropertiesSelect();
}

function addAvailableCategory(id, name) {
  $("#categoryToAdd").append('<option value="' + id + '">' + name + '</option>');
  toggleAvailableCategoriesSelect();
}

function removeAvailableCategory(id) {
  $("#categoryToAdd option[value='" + id + "']").remove();
  toggleAvailableCategoriesSelect();
}

function toggleAvailablePropertiesSelect() {
  if ($('#propertyToAdd option').size() > 0) {
    $('#availablePropertiesContainer').show();
  } else {
    $('#availablePropertiesContainer').hide();
  }
}

function toggleAvailableCategoriesSelect() {
  if ($('#categoryToAdd option').size() > 0) {
    $('#availableCategoriesContainer').show();
  } else {
    $('#availableCategoriesContainer').hide();
  }
}

function removeProperty(confirmMessage, id) {
  if (confirm(confirmMessage)) {
    var properties = $('#addedPropertiesTable').data('properties');
    
    for (var i = 0; i < properties.length; i++) {
      if (id == properties[i].id) {
        var selectedPropertyName = properties[i].name;
        break;
      }
    }

    $('#propertyLineTemplate' + id).remove();
    addAvailableProperty(id, selectedPropertyName);
  }
}

function removeCategory(confirmMessage, id) {
  if (confirm(confirmMessage)) {
    var categories = $('#addedCategoriesTable').data('categories');
    
    for (var i = 0; i < categories.length; i++) {
      if (id == categories[i].id) {
        var selectedCategoryName = categories[i].name;
        break;
      }
    }

    $('#categoryLineTemplate' + id).remove();
    addAvailableCategory(id, selectedCategoryName);
  }
}

function validateNumber(value) {
  var numberRegex = /^[+-]?\d+(\.\d+)?([eE][+-]?\d+)?$/;
  return numberRegex.test(value);
}

function refreshUnitText() {
  var properties = $('#addedPropertiesTable').data('properties');

  var selectedPropertyId = $('#propertyToAdd').val();

  for (var i = 0; i < properties.length; i++) {
    if (selectedPropertyId == properties[i].id) {
      var selectedPropertyUnit = properties[i].unit;
      break;
    }
  }

  $('#propertyType').text(selectedPropertyUnit);
}


