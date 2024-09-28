-- macros/test_positive_clv.sql

{% macro test_positive_clv(model, column_name) %}

SELECT *
FROM {{ ref(model.identifier) }}  -- Use model.identifier to extract the string name
WHERE {{ column_name }} < 0

{% endmacro %}
