{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "alertmanager.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "alertmanager.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}


{{/*
Return the appropriate apiVersion for networkpolicy.
*/}}
{{- define "prometheus.networkPolicy.apiVersion" -}}
{{- if and (ge .Capabilities.KubeVersion.Minor "4") (le .Capabilities.KubeVersion.Minor "6") -}}
{{- print "extensions/v1beta1" -}}
{{- else if ge .Capabilities.KubeVersion.Minor "7" -}}
{{- print "networking.k8s.io/v1" -}}
{{- end -}}
{{- end -}}

{{/*
Return the appropriate apiVersion value to use for the prometheus-operator managed k8s resources
*/}}
{{- define "prometheus-operator.apiVersion" -}}
{{- if .Capabilities.APIVersions.Has "monitoring.coreos.com/v1" }}
{{- printf "%s" "monitoring.coreos.com/v1" -}}
{{- else -}}
{{- printf "%s" "monitoring.coreos.com/v1alpha1" -}}
{{- end -}}
{{- end -}}

{{/*
Prometheus operator requires for alertmanager config secret to follow the naming: alertmanager-{ALERTMANAGER_NAME}
*/}}
{{- define "config-secret.name" -}}
{{- if eq .Values.deploymentMode "PrometheusOperator" -}}
{{- printf "alertmanager-%s" .Release.Name -}}
{{- else }}
{{ template "alertmanager.fullname" . }}
{{- end -}}
{{- end -}}

