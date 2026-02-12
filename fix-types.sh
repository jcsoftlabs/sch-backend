#!/bin/bash
# Fix type errors by adding 'as string' assertions to req.params and req.query

# For all controllers, wrap req.params.id and req.query.* with 'as string'
for file in src/interfaces/http/controllers/*.ts; do
    # Fix req.params.id usage
    sed -i '' 's/\(await [a-zA-Z]*Service\.[a-zA-Z]*(\)id\([,)]\)/\1id as string\2/g' "$file"
    
    # Fix req.query.patientId usage
    sed -i '' 's/\(await [a-zA-Z]*Service\.[a-zA-Z]*(\)patientId\([,)]\)/\1patientId as string\2/g' "$file"
    
    # Fix testType usage
    sed -i '' 's/testType as LabTestType/testType as string as LabTestType/g' "$file"
done
