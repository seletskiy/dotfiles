XPTemplate priority=personal

XPTinclude
      \ _common/common

XPT s " \section{...}
\section{`title^}`cursor^

XPT ss " \subsection{...}
\subsection{`title^}`cursor^

XPT sss " \subsubsection{...}
\subsubsection{`title^}`cursor^

XPT e " \begin{enumerate}
\begin{enumerate}
    `cursor^
\end{enumerate}

XPT i " \item ...
\item `cursor^

XPT b wrap=cursor " \begin{...} ... \end{...}
\begin{`block^}
    `cursor^
\end{`block^}

XPT pb " \pagebreak
\pagebreak
