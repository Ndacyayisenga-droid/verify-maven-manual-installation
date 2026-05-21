Write-Host "🔍 Verifying Maven installation"

mvn -v

if ($LASTEXITCODE -ne 0) {
    throw "❌ Maven verification failed"
}

Write-Host "✅ Maven is working correctly"