{{/*
Expand the name of the chart.
*/}}
{{- define "timemachine.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Full name.
*/}}
{{- define "timemachine.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Common labels.
*/}}
{{- define "timemachine.labels" -}}
helm.sh/chart: {{ include "timemachine.name" . }}-{{ .Chart.Version | replace "+" "_" }}
{{ include "timemachine.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- with .Values.commonLabels }}
{{- toYaml . }}
{{- end }}
{{- end }}

{{/*
Selector labels.
*/}}
{{- define "timemachine.selectorLabels" -}}
app.kubernetes.io/name: {{ include "timemachine.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
ServiceAccount name.
*/}}
{{- define "timemachine.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "timemachine.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Credential secret name.
*/}}
{{- define "timemachine.secretName" -}}
{{- if .Values.credentials.createSecret }}
{{- printf "%s-creds" (include "timemachine.fullname" .) }}
{{- else }}
{{- .Values.credentials.existingSecret }}
{{- end }}
{{- end }}
